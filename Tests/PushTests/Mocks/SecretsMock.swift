//
//  SecretsMock.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation
import Secrets

class SecretsMock: Secrets {

    var value: String?

    override func get(key: Secrets.Key) -> String? {
        return value
    }

}
