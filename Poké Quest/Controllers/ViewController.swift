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
    var validOption = 0
    
    var imageViews = [UIImageView]()
    var activityIndicators = [UIActivityIndicatorView]()
    var buttons = [UIButton]()
    let dataProvider = DataProvider()
    
    var buttonColor = UIColor(white:1.0, alpha: 0.6)
    
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
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRandomBackground()
        imageViews = [imageView1, imageView3, imageView2, imageView4]
        activityIndicators = [activityIndicator1, activityIndicator3, activityIndicator2, activityIndicator4]
        buttons = [button1, button2, button3, button4]
        
        for button in buttons {
            button.layer.cornerRadius = button.frame.height/2.0
            button.backgroundColor = buttonColor
        }
        
        resetView()
        
        if allPokemonsNamedUrls.count == 0 {
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

    // MARK:  - Actions implementation
    
    @IBAction func responseButtonTapped(_ sender: UIButton) {
        var isCorrect = true
        buttons[validOption].backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.6)
        if sender.titleLabel?.text != pokemon?.name {
            sender.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)
            isCorrect = false
        }
        printMessageForCorrectAnswer(isCorrect)
    }
    
    // MARK: - Other private methods
    
    private func askPokemon() {
        resetView()
 
        // Let's hardcode the max pokemon number...
        let randomId = Int(arc4random_uniform(UInt32(allPokemonsNamedUrls.count)) + 1);
        print("getting \(randomId) pokemon")
        
        dataProvider.pokemon(withId: randomId) {
            response in
            
            if let pokemon = response as? Pokemon {
                print("... pokemon name: \(pokemon.name)")
                self.pokemon = pokemon
                self.setFormImages()
                self.setButtonNames()
            }
        }
    }
    
    private func setRandomBackground() {
        let random = Int(arc4random_uniform(7) + 1);
        let backgroundName = "wall\(random)"
        background.image = UIImage(named: backgroundName)
    }
    
    private func setFormImages() {
        guard let spriteCount = pokemon?.sprites.count else { return }
        
        for i in 0..<spriteCount {
            guard let urlString = pokemon?.sprites[i] else { continue }
            dataProvider.pokemonFormImage(withUrl: urlString) {
                response in
                
                if let image = response as? UIImage {
                    self.imageViews[i].image = image
                }
                self.activityIndicators[i].stopAnimating()
            }
        }
    }
    
    private func setButtonNames() {
        for button in buttons {
            var randomId = -1
            repeat {
                randomId = Int(arc4random_uniform(UInt32(allPokemonsNamedUrls.count)) + 1);
            } while randomId == pokemon?.id
            
            button.setTitle(allPokemonsNamedUrls[randomId].name, for: .normal)
        }
        
        validOption = Int(arc4random_uniform(UInt32(4)))
        buttons[validOption].setTitle(pokemon?.name, for: .normal)
    }
    
    private func resetView() {
        for imageView in imageViews {
            imageView.image = nil
        }
        for activityIndicator in activityIndicators {
            activityIndicator.startAnimating()
        }
        for button in buttons {
            button.setTitle("", for: .normal)
            button.backgroundColor = buttonColor
        }
    }
    
    private func printMessageForCorrectAnswer(_ isCorrect: Bool) {
        var message: String
        
        if isCorrect {
            message = "Great! You have guessed this Pokémon's name. Do yo want to try again?"
            
        }
        else {
            message = "Oh, no. This Pokémon is '\(pokemon?.name ?? "")'. Do yo want to try again?"
        }
        
        let alert = UIAlertController(title: "Poké Quest", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { alertAction in
            self.askPokemon()
            if isCorrect { self.setRandomBackground() }
        })
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

