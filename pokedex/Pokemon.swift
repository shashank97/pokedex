//
//  Pokemon.swift
//  pokedex
//
//  Created by Shashank on 5/28/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import Foundation

class Pokemon
{
    private var _name: String!
    private var _ID: Int!
    
    var name : String
    {
        if (_name == nil)
        {
            _name = ""
        }
        
        return _name
    }
    
    var ID : Int
    {
        if (_ID == nil)
        {
            _ID = 0
        }
        
        return _ID
    }

    init (name: String, ID: Int)
    {
        self._name = name
        self._ID = ID
    }
}
