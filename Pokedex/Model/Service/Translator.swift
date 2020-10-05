//
//  Translator.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

final class Translator {
    
    typealias Text = [String:String]
    typealias Lang = [String:Text]
    
    init() {self.translator["en"] = [:]}
        
    private var translator : Lang = [:]
    private var selectedLang = "en"
    
    var langs : [String] {
        return translator.keys.map({$0})
    }
    
    func set(NewLang:String) {
        self.translator[NewLang] = [:]
    }
    
    func select(Lang:String) {
        if self.langs.contains(Lang) {
            self.selectedLang = Lang
        }
    }
    
    func getKeys(Lang:String) -> [String] {
        return self.translator[Lang]?.keys.map({$0}) ?? []
    }
    
    func set(Key:String, NewText:String, ForLang:String) {
        
        if nil == self.translator[ForLang] {
            self.set(NewLang: ForLang)
        }
        
        self.translator[ForLang]?[Key] = NewText
    }
    
    func translate(Key:String) -> String? {
        return self.translator[self.selectedLang]?[Key]
    }
}

