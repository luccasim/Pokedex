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

final class PersistanceStore {
    
    static let shared = PersistanceStore()
    
    let pokemonStore = CoreDataStore<PokemonMO>()
    let translationStore = CoreDataStore<TranslationMO>()
    
    func removeData() {
        self.pokemonStore.removeAll()
        self.translationStore.removeAll()
    }
}
