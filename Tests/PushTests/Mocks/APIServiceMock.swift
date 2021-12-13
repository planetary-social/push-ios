//
//  APIServiceMock.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation
@testable import Push

class APIServiceMock: APIService {

    var updated = false

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void)) {
        updated = true
    }
    
}
