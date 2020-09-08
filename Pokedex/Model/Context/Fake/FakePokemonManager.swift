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
            Pokemon(id: 1, name: "Bulbazor", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 2, name: "Herbizar", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 3, name: "Florizar", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 4, name: "Salameche", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 5, name: "Reptincel", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/5.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 6, name: "Dracofeu", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 7, name: "Carapuce", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 8, name: "Carabaffe", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/8.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 9, name: "Tortank", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/9.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),
            Pokemon(id: 10, name: "Mister10", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/10.png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête."),

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
