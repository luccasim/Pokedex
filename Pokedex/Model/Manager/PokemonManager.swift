//
//  PokemonManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
        
    func fetchToList() -> [Pokemon]
    func add(Pokemon:Pokemon)
    func save()
    
}

class PokemonManager : DataManagerProtocol {
    
    private(set) var data: [Pokemon] = []
    
    static var shared = PokemonManager()
    
    func fetchToList() -> [Pokemon] {
        return self.data
    }
    
    func add(Pokemon: Pokemon) {
        if let index = self.data.firstIndex(where: {$0.id == Pokemon.id}) {
            self.data[index] = Pokemon
        } else {
            self.data.append(Pokemon)
        }
    }
    
    func save() {
        
    }
    
}
