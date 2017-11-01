//
//  Pokemon.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import Foundation

class Pokemon {
    
    var id: Int
    var name: String
    var forms: [NamedUrl]
    var form: Form?
    
    init(withJson json: [String: Any]) {
        
        id = json["id"] as? Int ?? 0
        name = json["name"] as? String ?? ""
        forms = NamedUrl.namedUrls(withArray: json["forms"] as? [[String: Any]])
    }
}
