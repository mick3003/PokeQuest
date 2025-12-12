//
//  DataProvider.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 1/11/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//
//  DataProvider class responds a bit to 'some kind of clean design pattern' as it abstracts internal app model from
//  json structure that is provided by server returning always data of in-app expected type.
//  If server eventually changes its json responses, it is here where we must modify
//  the code to adapt model creation in order to keep app working. It is not VIPER, but is something far from MVC!
//  DataProvider is more agnostic about connection problems, as it interacts with view controllers, and they can
//  do barely anything about this situation: they can only say "there was a connection problem" (users don't want to know about
//  a 500 ISE or 403 FR, or SLT...) simply, they don't mind!
//

import UIKit

typealias DataProviderCompletion = (_ response: Any?) -> Void

// Pokemon Data Provider
class DataProvider {
    
    private let connection = Connection()
    
    func pockemonCount(completion: @escaping DataProviderCompletion) {
        
        connection.connect(endpoint: "pokemon") {
            
            response, error in
            
            if let json = response as? [String: Any] {
                DispatchQueue.main.async {
                    completion(json["count"])
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func allPokemonNames(completion: @escaping DataProviderCompletion) {
        
        connection.connect(endpoint: "pokemon/?limit=900&offset=0") {
            
            response, error in
            
            if let json = response as? [String: Any] {
                let namedUrls = NamedUrl.namedUrls(withArray: json["results"] as? Array)
                
                var filteredNames = [NamedUrl] ()
                for nameUrl in namedUrls {
                    if nameUrl.name.count < 12 {
                        filteredNames.append(nameUrl)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(filteredNames)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func pokemon(withId id: Int, completion: @escaping DataProviderCompletion) {
        
        connection.connect(endpoint: "pokemon/\(id)") {
            
            response, error in
            
            if let json = response as? [String: Any] {
                let pokemon = Pokemon(withJson: json)
                
                DispatchQueue.main.async {
                    completion(pokemon)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func pokemonFormImage(withUrl url: String, completion: @escaping DataProviderCompletion) {
        
        connection.downloadImageData(fromUrl: url) {
            
            response, error in
            
            var image: UIImage?
            
            if let data = response as? Data {
                image = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    
    /*
    func pokemon(withId id: Int, completion: @escaping DataProviderCompletion) {
        
        connection.connect(endpoint: "pokemon/\(id)") {
            
            response, error in
            
            if let json = response as? [String: Any] {
                let pokemon = Pokemon(withJson: json)
                
                if pokemon.forms.count > 0 {
                    
                    self.connection.connect(endpoint: pokemon.forms[0].url) {
                        
                        response, error in
                        
                        if let json = response as? [String: Any] {
                            let form = Form(withJson: json)
                            pokemon.form = form
                        }
                        
                        DispatchQueue.main.async {
                            completion(pokemon)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(pokemon)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    */
}
