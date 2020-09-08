//
//  Pokemon.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

struct Pokemon : Identifiable {
    
    var id      : Int
    var name    : String
    var sprite  : String?
    var desc    : String?
    
}

extension Pokemon {
    
    var item : LoaderItem {
        return LoaderItem(fileName: self.name, request: URLRequest(url: URL(string: self.sprite!)!))
    }
}
