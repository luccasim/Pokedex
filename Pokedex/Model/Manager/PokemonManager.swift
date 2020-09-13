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

protocol DataManagerProtocol {
        
    func add(Pokemon:Pokemon)
    func update(Pokemon:Pokemon)
    func save()
    
    func fetchToList() -> Future<[Pokemon],Never>
    func getImage(Pokemon:Pokemon) -> Future<UIImage,Never>
    
}

final class PokemonManager : DataManagerProtocol {
        
    static var shared = PokemonManager()
    
    private var store = PokemonStore.shared
    private var loader = ImageLoader.shared
    private var ws = PokeAPI()
    
    func fetchToList() -> Future<[Pokemon],Never> {
        
        return Future <[Pokemon],Never> { promise in
            
            let results = self.store.fetch()
            
            switch results {
            case .success(let mo):
                
                if mo.isEmpty {
                    self.ws.installPokemon(Ids: (1...151).map{$0}, Completion: { (res) in
                        switch res {
                        case .success(let reponses):
                                 
                            DispatchQueue.main.async {
                                reponses.0.forEach({self.update(Pokemon:Pokemon(id: $0.id, name: $0.name, sprite: nil, desc: $0.text[16].flavor_text))})
                                reponses.1.forEach({self.update(Pokemon: Pokemon(id: $0.id, name: $0.name, sprite: $0.sprites.other.official.front_default, desc: nil))})
                                
                                self.store.save()
                                let fetchs = self.store.fetch()
                                switch fetchs {
                                case .success(let mos): promise(.success(mos.map({$0.toPokemon}).sorted(by: {$0.id < $1.id})))
                                default: break
                                }
                            }
                            
                        default: break
                        }
                    })
                }
                else {
                    promise(.success(mo.map({$0.toPokemon}).sorted(by: {$0.id < $1.id})))
                }
                
            default: break
            }
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
