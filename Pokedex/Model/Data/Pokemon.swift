//
//  Pokemon.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

struct Pokemon : Identifiable {
    
    let id      : Int
    let name    : String
    let icon    : URL
    let sprite  : URL
    let desc    : String
    let type1   : Type
    
    var type2   : Type = .none
    var isInstalled = false
    
    let stats : Stats
    var audio : URL?
    
    struct Stats  {
        let hp, atk, def, atkS, defS, speed : Int
    }
}

extension Pokemon {
    
    static var Fake : Pokemon {
        return Pokemon(id: 0,
                       name: "Bulbizarre",
                       icon: URL(fileURLWithPath: "bulbazor"),
                       sprite: URL(fileURLWithPath: "bulbazor"),
                       desc: "He love Senzu",
                       type1: .plante,
                       type2: .vol,
                       isInstalled: true,
                       stats: Stats(hp: 45, atk: 49, def: 49, atkS: 65, defS: 65, speed: 45)
        )
    }
}
