//
//  APIService.swift
//  
//
//  Created by Martin Dutra on 13/12/21.
//

import Foundation

protocol APIService {

    func update(_ token: Data?, for identity: Identity, completion: @escaping ((PushError?) -> Void))
    
}
