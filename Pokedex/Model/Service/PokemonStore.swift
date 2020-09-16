//
//  PokemonMO.swift
//  Pokedex
//
//  Created by owee on 05/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData
import LCFramework

public class TranslationMO : NSManagedObject {
    
}


final class PokemonStore: CoreDataStore<PokemonMO> {
    
    static let shared = PokemonStore()
    
    func retrieveTranslations() {
        
        let translator = Translator.shared
        let mos = try! self.fetch().get()
        
        mos.forEach { (pmo) in
            
            if let translations = pmo.translations?.allObjects as? [TranslationMO] {
                translations.forEach { (tmo) in
                    if let key = tmo.key, let text = tmo.text, let lang = tmo.lang {
                        translator.set(Key: key, NewText: text, ForLang: lang)
                    }
                }
            }
        }
    }
}
