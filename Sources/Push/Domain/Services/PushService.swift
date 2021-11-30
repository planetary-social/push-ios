//
//  File.swift
//  
//
//  Created by Martin Dutra on 10/9/21.
//

import Foundation

protocol PushService {

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void))

}
