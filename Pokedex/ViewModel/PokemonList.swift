//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol PokemonListProtocol {
    
    var pokemons : [Pokemon] {get}
    var title : String {get}
    
    func fetchPokemon()
}

protocol PokemonListCellProtocol {
    
    var pokemon : Pokemon {get}
    var id : String {get}
    var name : String {get}
    var image : UIImage {get}
    
}

final class PokemonList : ObservableObject, PokemonListProtocol {
    
    @Published var pokemons: [Pokemon]
    
    private var manager : DataManagerInterface
    
    init(Manager:DataManagerInterface = DataManager.shared) {
        self.manager = Manager
        self.pokemons = []
    }
    
    var title: String {
        return NSLocalizedString("List Name", comment: "Name appear on the list pokemon")
    }
    
    func fetchPokemon() {
        self.pokemons = manager.fetchToList()
    }
    
}

final class PokemonListCell : ObservableObject, PokemonListCellProtocol {
    
    @Published var image: UIImage
    
    var pokemon: Pokemon
    var id: String
    var name: String
    var loader = ImageLoader.shared

    init(Pokemon:Pokemon) {
        self.pokemon = Pokemon
        self.id = Pokemon.id.description
        self.name = Pokemon.name.translate
        self.image = UIImage()
    }
    
    func loadImage() {
        
        self.loader.load(Url: self.pokemon.icon) { [weak self] (res) in
            
            DispatchQueue.main.async {
                switch res {
                case .success(let img): self?.image = img
                default : break
                }
            }
        }
    }
}
