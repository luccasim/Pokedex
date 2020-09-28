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
        trace("\(low)...\(high) Pokemon(s)")
        return (low...high).map{$0}
    }
    
    static var loadingTime : Double {
        let loadingTime = Double(infoPlist(Key: "LoadingTimeAnimation") ?? "2") ?? 2.0
        trace("Loading Time Animation \(loadingTime) second(s)")
        return loadingTime
    }
}

private func trace(_ str:String) {
    print("[Configuration] : \(str)")
}
