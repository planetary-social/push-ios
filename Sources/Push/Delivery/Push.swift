//
//  Push.swift
//
//
//  Created by Martin Dutra on 10/9/21.
//

import Foundation

public class Push {

    public static let shared = Push(service: PushServiceAdapter(apiService: PlanetaryService()))

    var service: PushService

    init(service: PushService) {
        self.service = service
    }

    public func update(_ token: Data?, for identity: String, completion: @escaping ((Error?) -> Void)) {
        service.update(token, for: Identity(identifier: identity), completion: completion)
    }

}
