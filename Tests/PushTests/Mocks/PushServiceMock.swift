//
//  PushServiceMock.swift
//  
//
//  Created by Martin Dutra on 30/11/21.
//

import Foundation
@testable import Push

class PushServiceMock: PushService {
    var updated: Bool = false

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void)) {
        updated = true
    }

}
