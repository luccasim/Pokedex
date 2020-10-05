//
//  ConfigManager.swift
//  Pokedex
//
//  Created by owee on 20/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol ConfigInterface {
    
    var generationRang : [Int] {get}
    var loadingTime : Double {get}
    var resetDatabase : Bool {get}
    
}

final class ConfigManager {
    
    static let shared  = ConfigManager()
    private let infosDict = Bundle.main.infoDictionary!
    
    private let settings = SettingManager.shared
    
    struct Keys {
        static let generation = "Generation"
        static let loadingTime = "LoadingTime"
        static let resetDatabase = "Reset"
    }
    
    func trace(_ str:String) {
        print("[ConfigManager] : \(str)")
    }
    
    enum Generation : String {
        case I, II, III, IV, V, VI, VII
        
        var rang : [Int] {
            switch self {
            case .I:    return (1...151).map({$0})
            case .II:   return (152...251).map({$0})
            case .III:  return (252...386).map({$0})
            case .IV:   return (387...494).map({$0})
            case .V:    return (495...649).map({$0})
            case .VI:   return (650...721).map({$0})
            case .VII:  return (722...809).map({$0})
            }
        }
    }
}

extension ConfigManager : ConfigInterface {
    
    var generationRang: [Int] {
        return (infosDict[Keys.generation] as? String).flatMap({Generation(rawValue: $0)?.rang}) ?? settings.generation.flatMap({Generation(rawValue: $0)?.rang}) ?? Generation.I.rang
    }
    
    var loadingTime: Double {
        return self.infosDict[Keys.loadingTime] as? Double ?? 2.0
    }
    
    var resetDatabase: Bool {
        return self.infosDict[Keys.resetDatabase] as? Bool ?? settings.shouldResetData
    }
}
