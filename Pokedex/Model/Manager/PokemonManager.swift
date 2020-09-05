//
//  PokemonManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import UIKit

protocol DataManagerProtocol {
        
    func fetchToList() -> [Pokemon]
    func add(Pokemon:Pokemon)
    func update(Pokemon:Pokemon)
    func save()
    
}

class PokemonManager : DataManagerProtocol {
        
    static var shared = PokemonManager()
    
    private var store = PokemonCoreData()
    
    func fetchToList() -> [Pokemon] {
        
        let results = self.store.fetch()
        switch results {
        case .success(let ents):
            return ents.map({$0.toPokemon})
        default: return []
        }
    }
    
    func add(Pokemon: Pokemon) {
        
        let new = self.store.create()
        
        new.id = Int16(Pokemon.id)
        new.name = Pokemon.name
        
        self.save()
    }
    
    func update(Pokemon: Pokemon) {
        self.store.update(Pokemon: Pokemon)
    }
    
    func save() {
        self.store.save()
    }
    
}
