//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol PokemonDetailVMProtocol {
    
    var name: String {get}
    var imageName : String {get}
    var infos : String {get}
    
}

final class PokemonDetailViewModel : PokemonDetailVMProtocol, ObservableObject {
    
    @Published private var pokemon : Pokemon?
    
    func set(Pokemon:Pokemon) {
        self.pokemon = Pokemon
    }
    
    var name : String {
        return self.pokemon?.name ?? "404"
    }
    
    var imageName: String {
        return self.pokemon?.sprite ?? "404"
    }
    
    var infos : String {
        return self.pokemon?.desc ?? "404"
    }
}
