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

public class PokemonMO : NSManagedObject {
    
    var toPokemon : Pokemon? {
        let id = Int(self.id)
        guard let name = self.name else {return nil}
        guard let desc = self.desc else {return nil}
        guard let url = self.sprite else {return nil}
        guard let icon = self.icon else {return nil}
        return Pokemon(id: id, name: name, icon: icon, sprite: url, desc: desc, type1: .none)
    }
    
    func setSpecies(Reponse:PokeAPI.SpeciesReponse) {
        self.id = Int16(Reponse.id)
        self.setTranslations(Reponse: Reponse)
        self.setNames(Reponse: Reponse)
    }
    
    func setPokemon(Reponse:PokeAPI.PokemonReponse) {
        self.id = Int16(Reponse.id)
        self.icon = URL(string: Reponse.sprites.front_default)
        self.sprite = URL(string: Reponse.sprites.other.official.front_default)
    }
    
    func setNames(Reponse:PokeAPI.SpeciesReponse) {
        let names = Reponse.names
        self.name = "name_\(Reponse.id)"
        names.forEach { (name) in
            let mo = TranslationMO(context: self.managedObjectContext!)
            mo.id = self.id
            mo.key = "name_\(Reponse.id)"
            mo.text = name.name
            mo.lang = name.language.name
            self.addToTranslations(mo)
        }
    }
    
    func setTranslations(Reponse:PokeAPI.SpeciesReponse) {
        let texts = Reponse.text
        self.desc = "desc_\(Reponse.id)"
        texts.forEach { (text) in
            let mo = TranslationMO(context: self.managedObjectContext!)
            mo.id = self.id
            mo.key = "desc_\(Reponse.id)"
            mo.text = text.flavor_text.replacingOccurrences(of: "\n", with: " ")
            mo.lang = text.language.name
            self.addToTranslations(mo)
        }
    }
    
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
