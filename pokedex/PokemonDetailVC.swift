//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Shashank on 5/29/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController
{
    //var that will receive the information sent when a cell is tapped 
    var pokemon: Pokemon!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var defense: UILabel!
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var pokeID: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var attack: UILabel!
    
    @IBOutlet weak var nextEvolutionLabel: UILabel!
    
    @IBOutlet weak var beforeEvolution: UIImageView!
    
    @IBOutlet weak var nextEvolution: UIImageView!
    
    @IBAction func backButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        label.text = pokemon.name.capitalized 
        super.viewDidLoad()
        
        let img = UIImage (named: "\(pokemon.ID)")
        mainImage.image = img
        beforeEvolution.image = img
        
        pokemon.pokemonDownloadDetails
        {
            //whatever we write here is only called after the network call is complete
            self.updateUI ()
        }
    }
    
    func updateUI ()
    {
        attack.text = pokemon.attack
        defense.text = pokemon.defense
        height.text = pokemon.height
        weight.text = pokemon.weight
        pokeID.text = "\(pokemon.ID)"
        type.text = pokemon.type
        descriptionLabel.text = pokemon.description
        
        if pokemon.nextEvolutionID == ""
        {
            nextEvolutionLabel.text = "No evolutions"
            nextEvolution.isHidden = true
        }
        
        else
        {
            nextEvolution.isHidden = false
            nextEvolution.image = UIImage (named: pokemon.nextEvolutionID)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - Level \(pokemon.nextEvolutionLevel)"
            nextEvolutionLabel.text = str
        }
    }
}
