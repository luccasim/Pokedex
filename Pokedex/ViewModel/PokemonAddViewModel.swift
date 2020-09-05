//
//  PokemonAddViewModel.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol PokemonAddVMP {
    func add(PokemonName:String)
}

final class PokemonAddViewModel : PokemonAddVMP {
    
    private let manager : DataManagerProtocol
    
    init(Manager:DataManagerProtocol = PokemonManager.shared) {
        self.manager = Manager
    }
    
    func add(PokemonName: String) {
        let pokemon = Pokemon(id: 1, name: PokemonName)
        self.manager.add(Pokemon: pokemon)
    }
}
