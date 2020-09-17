//
//  PokemonMO.swift
//  Pokedex
//
//  Created by owee on 17/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData

public class PokemonMO : NSManagedObject {
    
    var t1 : Int {
        return Int(self.type1?.replacingOccurrences(of: "https://pokeapi.co/api/v2/type/", with: "").replacingOccurrences(of: "/", with: "") ?? "-1") ?? -1
    }
    
    var t2 : Int {
        return Int(self.type2?.replacingOccurrences(of: "https://pokeapi.co/api/v2/type/", with: "").replacingOccurrences(of: "/", with: "") ?? "-1") ?? -1
    }
    
    func checkIfInstalled() {
        if self.toPokemon != nil {
            self.isInstalled = true
        }
    }
    
    var toPokemon : Pokemon? {
        
        let id = Int(self.id)
        
        guard let name = self.name else {return nil}
        guard let desc = self.desc else {return nil}
        guard let url = self.sprite else {return nil}
        guard let icon = self.icon else {return nil}
        
        let type1 = Type(rawValue: t1) ?? .none
        let type2 = Type(rawValue: t2) ?? .none
        
        return Pokemon(id: id, name: name, icon: icon, sprite: url, desc: desc, type1: type1, type2:type2)
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
        self.type1 = (Reponse.types.count > 0) ? Reponse.types[0].type.url : nil
        self.type2 = (Reponse.types.count > 1) ? Reponse.types[1].type.url : nil
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
extension PokemonMO : PokeAPIModel {
    
    var typeId1: String? {
        get {
            self.type1
        }
        set {
            self.type1 = newValue
        }
    }
    
    var typeId2: String? {
        get {
            self.type2
        }
        set {
            self.type2 = newValue
        }
    }
    
    var pokemonID: Int {
        return Int(self.id)
    }
    
    func setTypes(Reponse: PokeAPI.TypeReponse) {
        let names = Reponse.names
        
        names.forEach { (name) in
            let mo = TranslationMO(context: self.managedObjectContext!)
            mo.id = self.id
            mo.key = "type_\(Reponse.id)"
            mo.text = name.name
            mo.lang = name.language.name
            self.addToTranslations(mo)
        }
    }
    
}
