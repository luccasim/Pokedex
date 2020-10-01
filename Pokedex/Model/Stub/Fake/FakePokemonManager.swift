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

class FakePokemonManager  {
    
    func loadTranslation() {
    }
    
    func install(PokemonIds: [Int]) -> Future<Bool, Never> {
        return Future <Bool,Never> { promise in
            promise(.success(true))
        }
    }

    private var data : [Pokemon] = (0...15).map{_ in Pokemon.Fake}
    
    init() {}
    
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
