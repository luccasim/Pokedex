//
//  PokemonMO.swift
//  Pokedex
//
//  Created by owee on 05/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData
import LCFramework

class PokemonMO : NSManagedObject {
    
    var toPokemon : Pokemon {
        let id = Int(self.id)
        let name = self.name ?? "unknow"
        let desc = self.desc
        let url = self.sprite?.absoluteString
        return Pokemon(id: id, name: name, sprite: url, desc: desc)
    }
    
}

final class PokemonStore: CoreDataStore<PokemonMO> {
    
    static let shared = PokemonStore()
        
    func update(Pokemon:Pokemon) {
        
        let mo = self.get(Predicate: "id == \(Pokemon.id)") ?? self.create()
        
        mo.id = Int16(Pokemon.id)

        if let name = Pokemon.name {
            mo.name = name
        }

        if let desc = Pokemon.desc {
            mo.desc = desc
        }
        
        if let url = Pokemon.sprite.flatMap({URL(string: $0)}) {
            mo.sprite = url
        }
    }
}
