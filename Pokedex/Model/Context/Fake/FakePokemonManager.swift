//
//  FakePokemonManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation


class FakePokemonManager : DataManagerProtocol {
    
    private var data : [Pokemon] = []
    
    init() {
        self.data = [
            Pokemon(id: 1, name: "Bulbazor", sprite: "bulbazor", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 2, name: "Herbizarre"),
            Pokemon(id: 3, name: "Florizarre"),
            Pokemon(id: 4, name: "Salemeche"),
            Pokemon(id: 5, name: "Reptincel"),
            Pokemon(id: 6, name: "Dracofeu"),
            Pokemon(id: 7, name: "Carapuce"),
            Pokemon(id: 8, name: "Carabaffe"),
            Pokemon(id: 9, name: "Tortank")
        ]
    }
    
    func fetchToList() -> [Pokemon] {
        self.data
    }
    
    func add(Pokemon: Pokemon) {
        self.data.append(Pokemon)
    }
    
    func update(Pokemon: Pokemon) {
        
    }
    
    func save() {
        
    }
}
