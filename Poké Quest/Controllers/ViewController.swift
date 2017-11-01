//
//  ViewController.swift
//  Poké Quest
//
//  Created by Miguel Estévez on 31/10/17.
//  Copyright © 2017 Miguel Estévez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pokemon: Pokemon?
    var allPokemonsNamedUrls = [NamedUrl]()
    
    var imageViews = [UIImageView]()
    var activityIndicators = [UIActivityIndicatorView]()
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var activityIndicator1: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator2: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator3: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator4: UIActivityIndicatorView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRandomBackground()
        imageViews = [imageView1, imageView3, imageView2, imageView4]
        activityIndicators = [activityIndicator1, activityIndicator3, activityIndicator2, activityIndicator4]
        
        resetFormImages()
        
        if allPokemonsNamedUrls.count == 0 {
            let dataProvider = DataProvider()
            dataProvider.allPokemonNames(completion: {
                response in
                
                if let namedUrls = response as? [NamedUrl] {
                    self.allPokemonsNamedUrls = namedUrls
                }
                self.askPokemon()
            })
        }
        else {
            askPokemon()
        }
    }

    func askPokemon() {
        resetFormImages()
 
        // Let's hardcode the max pokemon number...
        let randomId = Int(arc4random_uniform(UInt32(allPokemonsNamedUrls.count)) + 1);
        print("getting \(randomId) pokemon")
        let dataProvider = DataProvider()
        dataProvider.pokemon(withId: randomId) {
            response in
            
            if let pokemon = response as? Pokemon {
                
                self.pokemon = pokemon
                self.setFormImages()
            }
        }
    }
    
    func setRandomBackground() {
        let random = Int(arc4random_uniform(7) + 1);
        let backgroundName = "wall\(random)"
        background.image = UIImage(named: backgroundName)
    }
    
    func downloadInitialData(completion: () -> Void) {
        
    }
    
    func setFormImages() {
        for i in 0...3 {
            let dataProvider = DataProvider()
            
            if let urlString = pokemon?.form?.sprites[i] {
                dataProvider.pokemonFormImage(withUrl: urlString) {
                    response in
                    
                    if let image = response as? UIImage {
                        self.imageViews[i].image = image
                    }
                    self.activityIndicators[i].stopAnimating()
                }
            }
        }
    }
    
    func resetFormImages() {
        for imageView in imageViews {
            imageView.image = nil
        }
        for activityIndicator in activityIndicators {
            activityIndicator.startAnimating()
        }
    }
}

