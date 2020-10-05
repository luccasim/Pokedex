//
//  SettingsManager.swift
//  Pokedex
//
//  Created by owee on 03/10/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol SettingInterface {
    
    var shouldResetData : Bool {get}
    var generation : String? {get}
    
}

final class SettingManager {
    
    static let shared = SettingManager()
    fileprivate let manager = UserDefaults.standard
    
    struct SettingKey {
        static let reset = "reset_setting"
        static let generation = "generation_setting"
    }
}

extension SettingManager : SettingInterface {
    
    var shouldResetData: Bool {
        if manager.bool(forKey: SettingKey.reset) {
            manager.setValue(false, forKey: SettingKey.reset)
            return true
        }
        return false
    }
    
    var generation: String? {
        return manager.string(forKey: SettingKey.generation)
    }

}
