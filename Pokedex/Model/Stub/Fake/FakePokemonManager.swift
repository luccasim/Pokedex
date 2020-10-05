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
import LCFramework
import AVFoundation

final class FakePokemonManager : DataManagerInterface {
    
    var imageLoader = DataLoader<UIImage>(Session: .shared, Convert: {UIImage(data: $0)})
    var audioLoader = DataLoader<AVAudioPlayer>(Session: .shared, Convert: {try? AVAudioPlayer(data: $0)})
    
    func resetData() {}
    
    func retrievePokemon(Rang: [Int]) -> [PokemonMO] {return []}
    
    func contain(Id: Int) -> Bool {
        true
    }
    
    func first(Id: Int) -> Pokemon? {
        Pokemon.Fake
    }
    
    func loadTranslation() {}
    
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
