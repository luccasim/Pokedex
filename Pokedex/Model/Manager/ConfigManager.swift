//
//  ConfigManager.swift
//  Pokedex
//
//  Created by owee on 20/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

final class ConfigManager {
    
    static func infoPlist(Key: String) -> String? {
        return Bundle.main.infoDictionary?[Key] as? String
    }
    
    static var pokemonRang : [Int] {
        guard let rang = (Bundle.main.infoDictionary?["PokemonRang"] as? [String]) else {
            return []
        }
        
        let low = Int(rang[0]) ?? 0
        let high = Int(rang[1]) ?? 0
        print("[Configuration] : \(low)...\(high) Pokemon(s)")
        return (low...high).map{$0}
    }
    
}
