//
//  NamedUrl.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import Foundation

class NamedUrl {
    
    var name: String
    var url: String
    
    init(withJson json: [String: Any]) {
        name = json["name"] as? String ?? ""
        url =  json["url"] as? String ?? ""
    }
    
    // Factory method...
    static func namedUrls(withArray array : [[String: Any]]?) -> [NamedUrl] {
        
        var retArray = [NamedUrl]()
        
        if let jsonArray = array {
            for json in jsonArray {
                let namedUrl = NamedUrl(withJson: json) // Not failable initializer...
                retArray.append(namedUrl)
            }
        }
        return retArray
    }
}
