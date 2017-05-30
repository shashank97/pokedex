//
//  Pokemon.swift
//  pokedex
//
//  Created by Shashank on 5/28/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import Foundation
//makes the network calls
import Alamofire

//blueprint for the pokemon that will be displayed in the pokedex
class Pokemon
{
    fileprivate var _name: String!
    fileprivate var _ID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolution: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionLevel : String!
    private var _pokemonURL : String!
    
    //getters:
    var nextEvolutionLevel : String
    {
        if (_nextEvolutionLevel == nil)
        {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
    }

    
    var nextEvolutionID : String
    {
        if (_nextEvolutionID == nil)
        {
            _nextEvolutionID = ""
        }
        
        return _nextEvolutionID
    }

    
    var nextEvolutionName : String
    {
        if (_nextEvolutionName == nil)
        {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }

    
//    var pokemonURL : String
//    {
//        if (_pokemonURL == nil)
//        {
//            _pokemonURL = ""
//        }
//        
//        return _pokemonURL
//    }
    
    var nextEvolution : String
    {
        if (_nextEvolution == nil)
        {
            _nextEvolution = ""
        }
        
        return _nextEvolution
    }
    
    var attack: String
    {
        if (_attack == nil)
        {
            _attack = ""
        }
        
        return _attack
    }
    
    var weight : String
    {
        if (_weight == nil)
        {
            _weight = ""
        }
        
        return _weight
    }
    
    var height : String
    {
        if (_height == nil)
        {
            _height = ""
        }
        
        return _height
    }
    
    var defense : String
    {
        if (_defense == nil)
        {
            _defense = ""
        }
        
        return _defense
    }
    
    var type : String
    {
        if (_type == nil)
        {
            _type = ""
        }
        
        return _type
    }
    
    var description : String
    {
        if (_description == nil)
        {
            _description = ""
        }
        
        return _description
    }
    
    //getter for name
    var name : String
    {
        if (_name == nil)
        {
            _name = ""
        }
        
        return _name
    }
    
    //getter for ID
    var ID : Int
    {
        if (_ID == nil)
        {
            _ID = 0
        }
        
        return _ID
    }

    //initializer function
    init (name: String, ID: Int)
    {
        self._name = name
        self._ID = ID
        
        //this is the url used to make the call
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.ID)/"
    }
    
    //only pull down info about pokemon when they are clicked
    func pokemonDownloadDetails (completed: @escaping DownloadComplete)
    {
        Alamofire.request (_pokemonURL).responseJSON
        {
            (response) in
            //get the dictionary (response.result.value) and cast that as a dictionary
            if let dict = response.result.value as? Dictionary <String, Any>
            {
                //go into dict and look for a key "weight", if found, we put it into our weight
                //same for other vars
                if let weight = dict ["weight"] as? String
                {
                    self._weight = weight
                }
                
                if let height = dict ["height"] as? String
                {
                    self._height = height
                }
                
                //the val for attack is stored as an int, therefore we have to cast as an int
                if let attack = dict ["attack"] as? Int
                {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict ["defense"] as? Int
                {
                    self._defense = "\(defense)"
                }
                
                
                //cast types as an arr of dicts bc there are multiple dicts in the arr named types
                //and if types.count > 0 then go into the arr
                if let types = dict ["types"] as? [Dictionary <String, String>], types.count > 0
                {
                    //if there is only 1 type
                    if let name = types [0] ["name"]
                    {
                        self._type = name.capitalized
                    }
                    
                    //if there are multiple types (meaning more than 1 elem in the arr)
                    if types.count > 1
                    {
                        //use for loop to traverse arr and grab and append each type to _type
                        for x in 1 ..< types.count
                        {
                            if let name = types [x] ["name"]
                            {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                
                else
                {
                    self._type = ""
                }
                
                //another arr of dicts
                if let descriptionArray = dict ["descriptions"] as? [Dictionary <String, String>], descriptionArray.count > 0
                {
                    //this time the description is actually stored in another link
                    if let url = descriptionArray [0] ["resource_uri"]
                    {
                        //completing the url
                        let url = "\(URL_BASE)\(url)"
                        
                        
                        //so we have to make a call to api and extract from there
                        Alamofire.request(url).responseJSON
                        {
                            (response) in
                            if let descriptionDictionary = response.result.value as? Dictionary <String, Any>
                            {
                                if let description = descriptionDictionary ["description"] as? String
                                {
                                    let newD = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newD
                                }
                            }
                            completed ()
                        }
                    }
                }
                
                else
                {
                    self._description = ""
                }
                
                if let evolutions = dict ["evolutions"] as? [Dictionary <String, Any>], evolutions.count > 0
                {
                    if let nextEvo = evolutions [0] ["to"] as? String
                    {
                        if nextEvo.range(of: "mega") == nil
                        {
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions [0] ["resource_uri"] as? String
                            {
                                let newS = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let newEvoID = newS.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionID = newEvoID
                                
                                if let levelExists = evolutions [0] ["level"]
                                {
                                    if let level = levelExists as? Int
                                    {
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                    
                                    else
                                    {
                                        self._nextEvolutionLevel = ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
        completed ()
        }
       
    }
}
