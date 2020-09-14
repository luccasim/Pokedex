//
//  PokemonManager.swift
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
    func update(Pokemon:Pokemon)
    func save()
    func loadTranslation()
    
    func fetchToList() -> [Pokemon]
    
    func getImage(Pokemon:Pokemon) -> Future<UIImage,Never>
    func install(PokemonIds:[Int]) -> Future<Bool,Never>
    
}

final class PokemonManager : PokemonManagerProtocol {
        
    static var shared = PokemonManager()
    
    private var store = PokemonStore.shared
    private var loader = ImageLoader.shared
    private var ws = PokeAPI()
    
    func install(PokemonIds:[Int]) -> Future<Bool, Never> {
        
        return Future<Bool, Never> { promise in
            
            guard self.fetchToList().isEmpty else {
                return promise(.success(true))
            }
            
            self.ws.installPokemon(Ids: PokemonIds) { (res) in
                
                switch res {
                case .success(let reponses):
                    
                    DispatchQueue.main.async {
                        
                        let mos = PokemonIds.map {_ in self.store.create()}
                
                        mos.enumerated().forEach { (i, mo) in
                            
                            mo.setSpecies(Reponse: reponses.0[i])
                            mo.setPokemon(Reponse: reponses.1[i])
                            
                        }
                        
                        self.store.save()
                        promise(.success(true))
                    }
                    
                default: break
                }
            }
        }
    }
    
    func fetchToList() -> [Pokemon] {
                    
        let results = self.store.fetch()
        
        switch results {
        case .success(let mo): return mo.map({$0.toPokemon}).sorted(by: {$0.id < $1.id})
        default: return []

        }
    }
    
    func loadTranslation() {
        self.store.retrieveTranslations()
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
    
    func getImage(Pokemon: Pokemon) -> Future<UIImage,Never> {
        
        return Future { (promise) in
            
            if let url = Pokemon.sprite.flatMap({URL(string: $0)}) {
                self.loader.load(Url: url) { (img) in
                    promise(.success(img))
                }
            }
        }
    }
}
