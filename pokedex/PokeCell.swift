//
//  PokeCell.swift
//  pokedex
//
//  Created by Shashank on 5/28/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

//allows us to manipulate the collection cells in the collection view
class PokeCell: UICollectionViewCell
{
    @IBOutlet weak var pokemonImage : UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    
    //creating a var. of type Pokemon, used to get data to fill the cell
    var pokemon : Pokemon!
    
    //for rounded corners on the cell:
    required init? (coder adecoder: NSCoder)
    {
        super.init (coder: adecoder)
        layer.cornerRadius = 5.0
    }
    
    //func. to call when we want to fill the cell with data
    func configureCell (_ pokemon: Pokemon)
    {
        self.pokemon = pokemon
        
        pokemonName.text = self.pokemon.name.capitalized
        pokemonImage.image = UIImage (named: "\(self.pokemon.ID)")
    }
}
