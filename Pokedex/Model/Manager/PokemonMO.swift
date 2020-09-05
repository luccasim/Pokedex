//
//  PokemonMO.swift
//  Pokedex
//
//  Created by owee on 05/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData

class PokemonMO : NSManagedObject {
    
    var toPokemon : Pokemon {
        let id = Int(self.id)
        let name = self.name ?? "unknow"
        return Pokemon(id: id, name: name)
    }
}

class PokemonCoreData: CoreDataHelper {
    
    var fetchRequest: NSFetchRequest<PokemonMO> {
        return PokemonMO.fetchRequest()
    }
    
    typealias Ent = PokemonMO
    
    func update(Pokemon:Pokemon) {
        let mo = self.get(Predicate: "id == \(Pokemon.id)")
        mo?.name = Pokemon.name
    }
    
}
