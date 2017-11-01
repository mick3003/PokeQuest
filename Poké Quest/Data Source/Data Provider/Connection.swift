//
//  Connection.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import UIKit

typealias ConnectionCompletion = (_ response: Any?, _ error: Error?) -> Void
typealias ImageCompletion = (_ image: UIImage?, _ error: Error?) -> Void

class Connection {
    
    var baseUrlString = "https://pokeapi.co/api/v2/"
    
    func connect(endpoint: String, completion: @escaping ConnectionCompletion) {
        
        let urlString = self.baseUrlString + endpoint
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = urlSession.dataTask( with: URL(string: urlString)! ) {
            
            data, response, error in
            
            if error == nil {
                if let data = data {
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    DispatchQueue.main.async {
                        completion(jsonData ?? [:], nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion([], nil)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func downloadImage(fromUrl url: String, completion: @escaping ImageCompletion) {
        
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: URL(string: url)! ) {
            
            data, response, error in
            
            if error == nil {
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        completion(image, nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
