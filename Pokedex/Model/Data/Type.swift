//
//  Type.swift
//  Pokedex
//
//  Created by owee on 16/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import SwiftUI

enum Type : Int {
    
    case none = -1
    case normal = 1
    case combat = 2
    case vol = 3
    case poison = 4
    case sol = 5
    case roche = 6
    case insect = 7
    case ghost = 8
    case acier = 9
    case feu = 10
    case eau = 11
    case plante = 12
    case electrique = 13
    case psy = 14
    case glace = 15
    case dragon = 16
    case dark = 17
    case fee = 18
    
}

extension Type {
    
    var isSet : Color {
        return self == .none ? Color.white : Color.black
    }
    
    var text:String {
        return "type_\(self.rawValue)".translate
    }
    
    var color:Color {
        switch self {
        case .normal: return Color(hex: "#A8A878") // A8A878
        case .combat: return Color(hex: "#C03028") // C03028
        case .vol: return Color(hex: "#A890F0") // A890F0
        case .poison: return Color(hex: "#A040A0") // A040A0
        case .sol: return Color(hex: "#E0C068") // E0C068
        case .roche: return Color(hex: "#B8A038") // B8A038
        case .insect: return Color(hex: "#A8B820") // A8B820
        case .ghost: return Color(hex: "#705898") // 705898
        case .acier: return Color(hex: "#B8B8D0") // B8B8D0
        case .feu: return Color(hex: "#F08030") // F08030
        case .eau: return Color(hex: "#6890F0") //6890F0
        case .plante: return Color(hex: "#78C850") //78C850
        case .electrique: return Color(hex: "#F8D030") //F8D030
        case .psy: return Color(hex: "#F85888") // F85888
        case .glace: return Color(hex: "#98D8D8") // 98D8D8
        case .dragon: return Color(hex: "#7038F8") // 7038F8
        case .dark: return Color(hex: "#705848") // 705848
        case .fee: return Color(hex: "#EE99AC") // EE99AC
        default:return Color.white
        }
    }
}

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
