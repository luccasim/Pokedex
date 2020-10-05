//
//  LocalizedManager.swift
//  Pokedex
//
//  Created by owee on 03/10/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol LocalizableInterface {
    
    var deviceLang : String {get}
    
    func setTranslation(Key:String, Value:String, Lang:String)
}

final class LocalizableManager{
    
    static let shared = LocalizableManager()
    fileprivate let translator : Translator
    
    private init() {
        let trans = Translator()
        let lang = Locale.current.languageCode ?? "en"
        trans.set(NewLang: lang)
        trans.select(Lang: lang)
        print("[LocalizableManager] : Device Lang = \(lang)")
        self.translator = trans
    }
}

extension LocalizableManager : LocalizableInterface {
    
    func setTranslation(Key: String, Value: String, Lang: String) {
        self.translator.set(Key: Key, NewText: Value, ForLang: Lang)
    }
    
    var deviceLang : String {
        return Locale.current.languageCode ?? "en"
    }
}

extension String {
    
    var translate : String {
        return LocalizableManager.shared.translator.translate(Key: self) ?? self
    }
}
