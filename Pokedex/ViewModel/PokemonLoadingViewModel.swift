//
//  PokemonLoadingViewModel.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import Combine

protocol PokemonLoadingViewModelProtocol {
    var isLoaded : Bool {get}
    var message : String {get}
    func loadPokemonData()
}

final class PokemonLoadingViewModel : ObservableObject, PokemonLoadingViewModelProtocol {
    
    @Published var isLoaded = false
    @Published var message: String = ""
    
    private var manager : PokemonManagerProtocol
    
    init(Manager:PokemonManagerProtocol=PokemonManager.shared) {
        self.manager = Manager
    }
    
    private var sub : AnyCancellable?
    
    
    
    func loadPokemonData() {
        
        self.message = "Loading Data"
        self.sub = self.manager.install(PokemonIds: (1...15).map({$0}))
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (success) in
                self.isLoaded = success
                self.message = "Press screen to Continue"
            })
    }
    
}
