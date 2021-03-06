//
//  DataManager.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import LCFramework
import Combine

protocol DataManagerInterface {
    
    var imageLoader : DataLoader<UIImage> {get}
    var audioLoader : DataLoader<AVAudioPlayer> {get}
        
    func add(Pokemon:Pokemon)
    func save()
    func resetData()
    func loadTranslation()
    
    func retrievePokemon(Rang:[Int]) -> [PokemonMO]
    
    func fetchToList() -> [Pokemon]
    func contain(Id:Int) -> Bool
    func first(Id:Int) -> Pokemon?
    
}

final class DataManager : DataManagerInterface {
        
    static var shared = DataManager()
    private var store = PersistanceStore.shared.pokemonStore
    private let localized : LocalizableManager
    
    let audioLoader = DataLoader<AVAudioPlayer>(Session: URLSession.shared, Convert: {try? AVAudioPlayer(data: $0)})
    let imageLoader = DataLoader<UIImage>(Session: URLSession.shared, Convert: {UIImage(data: $0)})
    
    init(Localized:LocalizableManager?=nil) {
        store.trace = true
        self.localized = Localized ?? LocalizableManager.shared
    }
    
    func fetchToList() -> [Pokemon] {
        
        let rang = ConfigManager.shared.generationRang
        let predicate = NSPredicate(format: "id >= \(rang.first!) && id <= \(rang.last!)")
        let results = self.store.fetch(Predicate: predicate)
        
        switch results {
        case .success(let mo):
            return mo.compactMap({$0.toPokemon}).sorted(by: {$0.id < $1.id})
        default: return []

        }
    }
    
    func retrievePokemon(Rang: [Int]) -> [PokemonMO] {
        return Rang.map {self.fetchOrCreate(id: $0)}
    }
    
    private func fetchOrCreate(id:Int) -> PokemonMO {
        guard let mo = self.store.first(Predicate: NSPredicate(format: "id == \(id)")) else {
            let mo = self.store.create()
            mo.id = Int16(id)
            return mo
        }
        return mo
    }
    
    func contain(Id: Int) -> Bool {
        return ConfigManager.shared.generationRang.contains(Id)
    }
    
    func first(Id: Int) -> Pokemon? {
        guard self.contain(Id: Id) else {
            return nil
        }
        return self.store.first(Predicate: NSPredicate(format: "id == \(Id)")).flatMap({$0.toPokemon})
    }
    
    func loadTranslation() {
        
        let predicate = NSPredicate(format: "lang == %@", localized.deviceLang)
        let res = PersistanceStore.shared.translationStore.fetch(Predicate: predicate)
        
        switch res {
        case .success(let mos):
            
            mos.forEach { (tmo) in
                
                if let key = tmo.key, let text = tmo.text, let lang = tmo.lang {
                    localized.setTranslation(Key: key, Value: text, Lang: lang)
                }
                
            }
            
        default: break
        }
    }
    
    func add(Pokemon: Pokemon) {
        
        let new = self.store.create()
        
        new.id = Int16(Pokemon.id)
        new.name = Pokemon.name
        
        self.save()
    }
    
    func save() {
        self.store.save()
    }
    
    func resetData() {
        self.store.removeAll()
    }
    
}
