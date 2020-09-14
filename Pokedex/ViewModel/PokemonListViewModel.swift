//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine

protocol PokemonListViewModelProtocol {
    
    var pokemons : [Pokemon] {get}
    var title : String {get}
    
    func fetchPokemon()
    
}

final class PokemonListViewModel : ObservableObject, PokemonListViewModelProtocol {
    
    @Published var pokemons: [Pokemon]
    
    private var manager : PokemonManagerProtocol
    
    init(Manager:PokemonManagerProtocol = PokemonManager.shared) {
        self.manager = Manager
        pokemons = []
    }
    
    var title: String {
        return "Pokedex"
    }
    
    func fetchPokemon() {
        self.pokemons = manager.fetchToList()
    }

}
