//
//  PlanetaryService.swift
//  
//
//  Created by Martin Dutra on 10/9/21.
//

import Foundation
import Secrets
import Logger

class PlanetaryService: PushService {

    private var scheme: String
    private var host: String
    private var port: Int
    private var path: String
    private var token: String?
    private var environment: String

    init() {
        self.scheme = "https"
        self.host = "us-central1-pub-verse-app.cloudfunctions.net"
        self.port = 443
        self.path = "/apns-service/apns"
        self.token = Secrets.shared.get(key: .push)
        #if DEBUG
        self.environment = "development"
        #else
        self.environment = "production"
        #endif
    }

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void)) {
        var json: [String: Any] = ["identity": identity.identifier]
        if let token = token {
            json["token"] = token.hexEncodedString()
        }
        json["environment"] = environment

        post(path: path, json: json, completion: completion)
    }

}

// MARK: API
extension PlanetaryService {

    func post(path: String, json: [String: Any], completion: @escaping ((PushError?) -> Void)) {
        guard let token = token else {
            completion(.missingToken)
            return
        }
        guard let body = json.data() else {
            completion(.encodeError)
            return
        }
        let headers = ["Content-Type": "application/json",
                       "planetary-push-authorize": token]

        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.port = self.port

        guard let url = components.url else {
            completion(.invalidURL)
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "planetary-push-authorize")
        request.httpMethod = "POST"
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            let pushError = response?.httpStatusCodeError ?? .optional(error)
            Logger.shared.optional(pushError, from: response)
            DispatchQueue.main.async {
                completion(pushError)
            }
        }.resume()
    }

}

fileprivate extension Data {

    // Borrowed from Stack Overflow
    // https://stackoverflow.com/questions/8798725/get-device-token-for-push-notification
    func hexEncodedString() -> String {
        let string = self.reduce("", {$0 + String(format: "%02X", $1)})
        return string
    }

}

fileprivate extension Dictionary {

    func data() -> Data? {
        let dictionary = self.copyByTransformingValues(of: Date.self) {
            date in
            return date.iso8601String
        }
        return try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }

    // This could support an array of transforms to prevent
    // looping multiple times for multiple value types.
    func copyByTransformingValues<T: Any>(of type: T.Type,
                                          using: ((T) -> String)) -> Dictionary<Key, Any>
    {
        var dictionary: [Key: Any] = [:]
        self.forEach {
            if let value = $0.value as? T   { dictionary[$0.key] = using(value) }
            else                            { dictionary[$0.key] = $0.value }
        }
        return dictionary
    }
}

fileprivate extension Date {

    private static let iso8601Formatter = ISO8601DateFormatter()

    var iso8601String: String {
        return Date.iso8601Formatter.string(from: self)
    }

}

fileprivate extension URLResponse {

    var httpStatusCodeError: PushError? {
        guard let response = self as? HTTPURLResponse else { return nil }
        if response.statusCode > 201 { return .httpStatusCode(response.statusCode) }
        else { return nil }
    }

}

extension Logger {

    func optional(_ error: PushError?, from response: URLResponse?) {
        guard let error = error else { return }
        guard let response = response else { return }
        let path = response.url?.path ?? "unknown path"
        let detail = "\(path) \(error)"
        self.unexpected(.apiError, detail)
    }

}
