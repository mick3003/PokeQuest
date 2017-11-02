//
//  Connection.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//
//  This is a helper class that does the http/https connection, indexes the base url, and provides functionality
//  to convert the NSData responsed by server into an NSDictionary object. Here we would add other post paramethers
//  (not required by exercise) and manage authentication challenges, login and/or token/session stuff.
//  Yet, this server does not implements authentication.
//

import UIKit

typealias ConnectionCompletion = (_ response: Any?, _ error: Error?) -> Void

class Connection {
    
    var baseUrlString = "https://pokeapi.co/api/v2/"
    
    func connect(endpoint: String, completion: @escaping ConnectionCompletion) {
        
        var urlString: String
        
        if endpoint.hasPrefix("http") {
            urlString = endpoint
        }
        else {
            urlString = self.baseUrlString + endpoint
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = urlSession.dataTask( with: URL(string: urlString)! ) {
            
            data, response, error in
            
            if error == nil {
                if let data = data {
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    completion(jsonData ?? [:], nil)
                }
                else {
                    completion([], nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func downloadImageData(fromUrl url: String, completion: @escaping ConnectionCompletion) {
        
        let urlSession = URLSession(configuration: .default)
        
        if let urlString = URL(string: url) {
            let task = urlSession.dataTask(with: urlString ) { data, response, error in completion(data, error) }
            task.resume()
        }
        else {
            completion(nil, nil)
        }
    }
}
