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
    
    func getImage(Pokemon:Pokemon) -> Future<UIImage,Never>
    func install(PokemonIds:[Int]) -> Future<Bool,Never>
    
    func fetchTranslation() -> [TranslationMO]
    
}

final class DataManager : PokemonManagerProtocol {
    
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
        
    static var shared = DataManager()
    private var store = PersistanceStore.shared.pokemonStore
    
    private var loader = ImageLoader.shared
    private var ws = PokeAPI()
    
    private var cancelInstall = Set<AnyCancellable>()
    
    func install(PokemonIds:[Int]) -> Future<Bool, Never> {
        
        return Future<Bool, Never> { promise in
            
            let toInstall = self.fetchUnInstalled(PokemonIds: PokemonIds)
            
            guard !toInstall.isEmpty else {
                return promise(.success(true))
            }
            
            let mos : [PokemonMO] = toInstall.map { id in
                let mo = self.store.create()
                mo.id = Int16(id)
                return mo
            }
            
            self.ws.installPokemon(Models: mos)
                .receive(on: RunLoop.main)
                .sink { (succed) in
                    
                    mos.forEach({$0.checkIfInstalled()})
                    self.store.save()
                    promise(.success(true))
            }
            .store(in: &self.cancelInstall)
        }
    }
        
    func fetchTranslation() -> [TranslationMO] {
        
        let res = PersistanceStore.shared.translationStore.fetch()
        
        do {
            let translation = try res.get()
            return translation
        } catch _ {
            return []
        }
    }
    
    private func fetchUnInstalled(PokemonIds:[Int]) -> [Int] {
        
        let result = self.store.fetch()
        
        switch result {
        case .success(let mo):
            
            // None installed
            if mo.isEmpty {
                return PokemonIds
            }
            
            // New Pokemon added
            if mo.count != PokemonIds.count {
                let news = PokemonIds.filter({id in
                    !mo.contains(where: {$0.id == id})
                })
                return news
            }
            
            // Stored but uninstalled
            return mo.filter{$0.isInstalled == false}.compactMap{Int($0.id)}
        default: return []
        }
    }
    
    func fetchToList() -> [Pokemon] {
                    
        let results = self.store.fetch()
        
        switch results {
        case .success(let mo):
            return mo.compactMap({$0.toPokemon}).sorted(by: {$0.id < $1.id})
        default: return []

        }
    }
    
    func loadTranslation() {
        
        do {
            
            let translator = Translator.shared
            let predicate = NSPredicate(format: "lang == %@", "fr")
            let mos = try PersistanceStore.shared.translationStore.fetch(Predicate: predicate).get()
            
            mos.forEach { (tmo) in
                
                if let key = tmo.key, let text = tmo.text, let lang = tmo.lang {
                    translator.set(Key: key, NewText: text, ForLang: lang)
                }
            }
            
        } catch _ {
            
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
    
    func getImage(Pokemon: Pokemon) -> Future<UIImage,Never> {
        
        return Future { (promise) in
            
            self.loader.load(Url: Pokemon.sprite) { (img) in
                promise(.success(img))
            }
        }
    }
    
}
