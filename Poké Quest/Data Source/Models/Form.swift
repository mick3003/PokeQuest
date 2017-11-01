//
//  Form.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import Foundation

class Form {
    
    var id: Int
    var name: String
    var sprites: [String]
    
    init(withJson json: [String: Any]) {
        
        id = json["id"] as? Int ?? 0
        name = json["name"] as? String ?? ""
        sprites = [String]()
        
        if let values = json["sprites"] as? [String: Any?] {
            
            sprites.append(values["front_default"] as? String ?? "")
            sprites.append(values["back_default"] as? String ?? "")
            sprites.append(values["front_shiny"] as? String ?? "")
            sprites.append(values["back_shiny"] as? String ?? "")
        }
    }
}
