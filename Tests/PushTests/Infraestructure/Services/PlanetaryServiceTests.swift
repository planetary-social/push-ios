//
//  File.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation
@testable import Push
import XCTest

class PlanetaryServiceTests: XCTestCase {

    var secrets: SecretsMock!
    var urlSession: URLSession!
    var service: PlanetaryService!

    override func setUp() {
        secrets = SecretsMock()
        secrets.value = "test-token"

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession(configuration: configuration)

        service = PlanetaryService(secrets: secrets, session: urlSession)
    }

    func testUpdate() {
        let expectedToken = "my-token".data(using: .utf8)
        let encoder = HexEncoder()
        let expectedTokenHex = encoder.encode(data: expectedToken!)

        var lastRequest: URLRequest?
        URLProtocolMock.requestHandler = { request in
            lastRequest = request
            let exampleData = "{}".data(using: .utf8)!
            let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }

        let expectation = XCTestExpectation()
        service.update(expectedToken, for: Identity(identifier: "user-hash")) { error in
            XCTAssertNil(error)

            XCTAssertNotNil(lastRequest)
            XCTAssertNotNil(lastRequest?.httpBodyStream)

            // Read http body
            let stream = lastRequest!.httpBodyStream!
            let data = NSMutableData()
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4096)
            stream.open()
            while stream.hasBytesAvailable {
                let length = stream.read(buffer, maxLength: 4096)
                if length == 0 {
                    break
                } else {
                    data.append(buffer, length: length)
                }
            }
            
            do {
                let object = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
                XCTAssertTrue(JSONSerialization.isValidJSONObject(object))
                let value = (object as? NSDictionary)?.value(forKey: "token") as? String
                XCTAssertEqual(value, expectedTokenHex)
            } catch {
                XCTFail()
            }

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}

