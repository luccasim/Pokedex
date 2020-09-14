//
//  FakePokemonManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine
import UIKit

class FakePokemonManager : PokemonManagerProtocol {
    
    func loadTranslation() {
    }
    
    func install(PokemonIds: [Int]) -> Future<Bool, Never> {
        return Future <Bool,Never> { promise in
            promise(.success(true))
        }
    }

    private var data : [Pokemon] = []
    
    init() {
        
        let data = (1...151).map({Pokemon(id: $0, name: "Pokemon \($0)", sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png", desc: "Il aime les cacahouettes.\nVous devriez lui en donner pour éviter de prendre une attaque lance soleil dans la tête.")})
        
        self.data = data
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
    
    func getImage(Pokemon: Pokemon) -> Future<UIImage, Never> {
        
        return Future { promise in
            ImageLoader.shared.load(Url: Pokemon.sprite.flatMap({URL(string: $0)})!) { (img) in
                promise(.success(img))
            }
        }
    }
    
}
