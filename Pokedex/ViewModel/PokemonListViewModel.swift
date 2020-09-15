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

protocol PokemonListViewModelProtocol {
    var pokemons : [Pokemon] {get}
    var title : String {get}
    
    func fetchPokemon()
}

protocol PokemonListCellViewModelProtocol {
    var pokemon : Pokemon {get}
    var id : String {get}
    var name : String {get}
    var image : UIImage {get}
}

final class PokemonListViewModel : ObservableObject, PokemonListViewModelProtocol {
    
    @Published var pokemons: [Pokemon]
    
    private var manager : PokemonManagerProtocol
    
    init(Manager:PokemonManagerProtocol = PokemonManager.shared) {
        self.manager = Manager
        self.pokemons = []
    }
    
    var title: String {
        return "Pokedex"
    }
    
    func fetchPokemon() {
        self.pokemons = manager.fetchToList()
    }
}

final class PokemonListCellViewModel : ObservableObject, PokemonListCellViewModelProtocol {
    
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
        self.loader.load(Url: self.pokemon.icon) { (img) in
            DispatchQueue.main.async {
                self.image = img
            }
        }
    }
    
}
