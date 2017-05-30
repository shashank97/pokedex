//
//  ViewController.swift
//  pokedex
//
//  Created by Shashank on 5/28/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit
//for audio/video
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    //Protocols and what they mean:
    //Delegate- this class will be the delegate
    //Data Source- the data will be contained within this class
    //Delegate Flow Layout = modify settings for the layout
    
    //this is the collection view which will be used
    @IBOutlet weak var collection : UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //create empty array of pokemon
    var pokemon = [Pokemon] ()
    //array that filters pokemon based on search text
    var filteredPokemon = [Pokemon]()
    //boolean for searchbar
    var inSearchMode = false //default value
    
    //music player variable
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad()
    {
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        //get info from CSV
        parsePokemonCSV()
        
        //play music
        initAudio()
        
        super.viewDidLoad()
    }
    
    //accessing the audio
    func initAudio ()
    {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do
        {
            //music player gets audio from path defined above
            musicPlayer = try AVAudioPlayer (contentsOf: URL (string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //will loop continuously
            musicPlayer.play()
        }
        
        catch let err as NSError
        {
            print (err.debugDescription)
        }
    }
    
    //create func to parse csv
    func parsePokemonCSV ()
    {
        //create a path to the pokemon.csv file:
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //do-catch block to handle any errors accessing the file
        do
        {
            let csv = try CSV (contentsOfURL: path)
            let rows = csv.rows
//            print (rows)
            
            //go through data using for loop
            for row in rows
            {
                //look for id and identifier and set to id and name
                let pokeID = Int (row ["id"]!)!
                let name = row ["identifier"]!
                
                //poke is an object of type Pokemon
                let poke = Pokemon (name: name, ID: pokeID)
                //pokemon is an array that can hold objects of type Pokemon
                pokemon.append (poke)
            }
            
        }
        //print err is any
        catch let err as NSError
        {
            print (err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //only loads the pokemon that appear on the screen instead of trying to load all 718 pokemon
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell
        {
            //fills different cells with different pokemons using the indexPath and getting info from the Pokemon class
            let poke : Pokemon!
            
            //load cells based on if in search mode or not
            if inSearchMode == true
            {
                poke = filteredPokemon [indexPath.row]
                cell.configureCell(poke)
            }
            
            else
            {
                poke = pokemon [indexPath.row]
                cell.configureCell(poke)
            }
            cell.configureCell(poke)
            
            return cell
        }
        
            //return empty if failure
        else
        {
            return UICollectionViewCell ()
        }
    }

    //will execute when a cell is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var poke : Pokemon!
        
        //changes depending on if in search mode
        if inSearchMode
        {
            poke = filteredPokemon [indexPath.row]
        }
        
        else
        {
            poke = pokemon [indexPath.row]
        }
        
        //switch to new VC when a cell is tapped
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    //sets the number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //load cells based on if in search mode or not
        if inSearchMode == true
        {
            return filteredPokemon.count
        }
        
        //return how many pokemon are in the array pokemon (718)
        return pokemon.count
    }
    
    //sets the number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    //defines the size of the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize (width: 105, height: 105)
    }
    
    @IBAction func musicPressed(_ sender: UIButton)
    {
        //pause if playing
        if musicPlayer.isPlaying 
        {
            musicPlayer.pause ()
            sender.alpha = 0.2
        }
        
        //play if paused
        else
        {
            musicPlayer.play ()
            sender.alpha = 1.0
        }
        
    }
    
    //remove keyboard if return is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //when we don't type anything
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            collection.reloadData()
            //removes keyboard
            view.endEditing(true)
        }
        
        else
        {
            inSearchMode = true
            
            //capturing the search bar text
            let lower = searchBar.text!.lowercased()
            
            //filtering the pokemon based on the search bar text
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            
            //reload data based on filtered list
            collection.reloadData()
        }
        
    }
    
    //prepare for segue and send as any obj
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //if segue is triggered from pdvc then
        if segue.identifier == "PokemonDetailVC"
        {
            //detailsvc is the destination (aka PokemonDetailVC)
            if let detailsvc = segue.destination as? PokemonDetailVC
            {
                //if the sender is poke and sends info of type Pokemon
                if let poke = sender as? Pokemon
                {
                    //pokemon obj in destination vc is of type Pokemon (poke)
                    detailsvc.pokemon = poke
                }
            }
        }
    }
    
}

