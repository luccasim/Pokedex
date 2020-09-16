//
//  Type.swift
//  Pokedex
//
//  Created by owee on 16/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import SwiftUI

enum Type : String {
    
    case none = ""
    case grass, poison
    
}

extension Type {
    
    var text:String {
        return "type_\(self.rawValue)".translate
    }
    
    var color:Color {
        switch self {
        case .grass: return Color.green
        case .poison: return Color.purple
        default:return Color.white
        }
    }
}
