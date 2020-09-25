//
//  DataManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import UIKit
import LCFramework
import Combine

protocol PokemonManagerProtocol {
        
    func add(Pokemon:Pokemon)
    func save()
    func resetData()
    func loadTranslation()
    
    func retrievePokemon(Rang:[Int]) -> [PokemonMO]
    
    func fetchToList() -> [Pokemon]
        
}

final class DataManager : PokemonManagerProtocol {
        
    static var shared = DataManager()
    private var store = PersistanceStore.shared.pokemonStore
    
    init() {
        store.trace = true
    }
    
    func fetchToList() -> [Pokemon] {
                    
        let results = self.store.fetch()
        
        switch results {
        case .success(let mo):
            return mo.compactMap({$0.toPokemon}).sorted(by: {$0.id < $1.id})
        default: return []

        }
    }
    
    func retrievePokemon(Rang: [Int]) -> [PokemonMO] {
        return Rang.map {self.fetchOrCreate(id: $0)}
    }
    
    private func fetchOrCreate(id:Int) -> PokemonMO {
        guard let mo = self.store.first(Predicate: NSPredicate(format: "id == \(id)")) else {
            let mo = self.store.create()
            mo.id = Int16(id)
            return mo
        }
        return mo
    }
    
    func loadTranslation() {
        
        let translator = Translator.shared
        let predicate = NSPredicate(format: "lang == %@", "fr")
        let res = PersistanceStore.shared.translationStore.fetch(Predicate: predicate)
        
        switch res {
        case .success(let mos):
            
            mos.forEach { (tmo) in
                
                if let key = tmo.key, let text = tmo.text, let lang = tmo.lang {
                    translator.set(Key: key, NewText: text, ForLang: lang)
                }
            }
            
        default: break
        }
    }
    
    func add(Pokemon: Pokemon) {
        
        let new = self.store.create()
        
        new.id = Int16(Pokemon.id)
        new.name = Pokemon.name
        
        self.save()
    }
    
    func save() {
        self.store.save()
    }
    
    func resetData() {
        self.store.removeAll()
    }
    
}
