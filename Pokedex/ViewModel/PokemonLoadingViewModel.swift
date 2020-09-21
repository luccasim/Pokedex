//
//  PokemonLoadingViewModel.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine
import LCFramework

protocol PokemonLoadingViewModelProtocol {
    
    var isLoaded : Bool {get}
    var message : String {get}
    
    func loadPokemonData()
}

final class PokemonLoadingViewModel : ObservableObject, PokemonLoadingViewModelProtocol {
    
    @Published var isLoaded = false
    @Published var message: String = ""
    
    private var manager : PokemonManagerProtocol
    
    let rang = ConfigManager.pokemonRang
    
    init(Manager:PokemonManagerProtocol=PokemonManager.shared) {
        
        self.manager = Manager
        
        Translator.shared.set(NewLang: "fr")
        Translator.shared.select(Lang: "fr")
        
//        PersistanceStore.shared.removeData()
    }
    
    private var sub : AnyCancellable?
    
    func loadPokemonData() {
        
        self.message = "Loading Data"
        self.sub = self.manager.install(PokemonIds: self.rang.map({$0}))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (success) in
                self.isLoaded = success
                self.message = "Press screen to Continue"
                self.manager.loadTranslation()
                self.sub = nil
            })
    }
    
}
