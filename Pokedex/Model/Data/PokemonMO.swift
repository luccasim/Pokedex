//
//  PokemonMO.swift
//  Pokedex
//
//  Created by owee on 17/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import CoreData
import LCPokeAPI

public class PokemonMO : NSManagedObject {
    
    
    var toPokemon : Pokemon? {
        
        let id = Int(self.id)
        
        guard let name = self.name else {return nil}
        guard let desc = self.desc else {return nil}
        guard let url = self.sprite else {return nil}
        guard let icon = self.icon else {return nil}
        
        let t1 = self.idType1 ?? -1
        let t2 = self.idType2 ?? -1
        let type1 = Type(rawValue: t1) ?? .none
        let type2 = Type(rawValue: t2) ?? .none
        
        let stat = Pokemon.Stats(
            hp: Int(self.hp),
            atk: Int(self.attack),
            def: Int(self.defense),
            atkS: Int(self.attSpe),
            defS: Int(self.defSpe),
            speed: Int(self.speed)
        )
        
        return Pokemon(
            id: id,
            name: name,
            icon: icon,
            sprite: url,
            desc: desc,
            type1: type1,
            type2:type2,
            stats: stat,
            audio:self.audioUrl
        )
    }

    private func Gen(id:Int) -> String? {
        switch id {
        case 1...151:       return "1"
        case 152...251:     return "2"
        case 252...386:     return "3"
        case 387...494:     return "4"
        case 495...649:     return "5"
        case 650...721:     return "6"
        case 722...809:     return "7"
        default: return nil
        }
    }
    
    var audioUrl : URL? {
        guard let name = self.baseName?.capitalized else {return nil}
        guard let gen = self.Gen(id: Int(self.id)) else {return nil}
        let id = String(format: "%03d", Int(self.id))

        return URL(string:"https://raw.githubusercontent.com/luccasim/media/main/pokemon/Gen\(gen)/\(id)%20-%20\(name).wav")
    }
    
    var idType1 : Int? {
        return Int(self.type1?.replacingOccurrences(of: "https://pokeapi.co/api/v2/type/", with: "").replacingOccurrences(of: "/", with: "") ?? "-1")
    }
    
    var idType2 : Int? {
        return Int(self.type2?.replacingOccurrences(of: "https://pokeapi.co/api/v2/type/", with: "").replacingOccurrences(of: "/", with: "") ?? "-1")
    }
    
    func checkIfInstalled() {
        if self.toPokemon != nil {
            self.isInstalled = true
        }
    }
    
    func setSpecies(Reponse:PokeAPI.SpeciesReponse) {
        self.id = Int16(Reponse.id)
        self.setTranslations(Reponse: Reponse)
        self.setNames(Reponse: Reponse)
    }
    
    func setPokemon(Reponse:PokeAPI.PokemonReponse) {
        
        self.id = Int16(Reponse.id)
        self.icon = URL(string: Reponse.sprites.front_default)
        self.baseName = Reponse.name
        
        if let url = Reponse.sprites.other.official.front_default ?? Reponse.sprites.versions.generation7.usul.front_default {
            self.sprite = URL(string: url)
        }
        
        self.type1 = (Reponse.types.count > 0) ? Reponse.types[0].type.url : nil
        self.type2 = (Reponse.types.count > 1) ? Reponse.types[1].type.url : nil
        
        self.hp = Int16(Reponse.stats[0].base_stat)
        self.attack = Int16(Reponse.stats[1].base_stat)
        self.defense = Int16(Reponse.stats[2].base_stat)
        self.attSpe = Int16(Reponse.stats[3].base_stat)
        self.defSpe = Int16(Reponse.stats[4].base_stat)
        self.speed = Int16(Reponse.stats[5].base_stat)
        
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

extension PokemonMO {

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
