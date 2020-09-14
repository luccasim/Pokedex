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

public class PokemonMO : NSManagedObject {
    
    var toPokemon : Pokemon {
        let id = Int(self.id)
        let name = self.name ?? "unknow"
        let desc = self.desc
        let url = self.sprite?.absoluteString
        return Pokemon(id: id, name: name, sprite: url, desc: desc)
    }
    
    func setSpecies(Reponse:PokeAPI.SpeciesReponse) {
        self.id = Int16(Reponse.id)
        self.setTranslations(Reponse: Reponse)
    }
    
    func setPokemon(Reponse:PokeAPI.PokemonReponse) {
        self.id = Int16(Reponse.id)
        self.name = Reponse.name
        self.sprite = URL(string: Reponse.sprites.front_default)
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
        
    func update(Pokemon:Pokemon) {
        
        let mo = self.get(Predicate: "id == \(Pokemon.id)") ?? self.create()
        
        mo.id = Int16(Pokemon.id)

        if let name = Pokemon.name {
            mo.name = name
        }

        if let desc = Pokemon.desc {
            mo.desc = desc
        }
        
        if let url = Pokemon.sprite.flatMap({URL(string: $0)}) {
            mo.sprite = url
        }
    }
}
