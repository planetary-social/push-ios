//
//  PushServiceAdapter.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation
import Logger

class PushServiceAdapter: PushService {

    var apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void)) {
        Logger.shared.debug("Sending push token from \(identity.identifier)...")
        apiService.update(token, for: identity, completion: completion)
    }

}
