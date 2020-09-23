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

final class LoadingVM : ObservableObject, PokemonLoadingViewModelProtocol {
    
    @Published var isLoaded = false
    @Published var message: String = "Loading..."
    
    private var manager : PokemonManagerProtocol
    private let rang = ConfigManager.pokemonRang
    private let pokeapiWS = PokeAPI()
    
    private var cancellable = Set<AnyCancellable>()
    
    init(Manager:PokemonManagerProtocol=DataManager.shared) {
        
        self.manager = Manager
        Translator.shared.set(NewLang: "fr")
    }
    
    private func finish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoaded = true
            self.message = "Press to Continue"
            Translator.shared.select(Lang: "fr")
            self.manager.loadTranslation()
        }
    }
    
    private func toFuture(Model:PokemonMO) -> Future<PokemonMO, Never> {
        return Future<PokemonMO,Never> { promise in
            
            self.pokeapiWS.modelTasks(Model: Model)
                .flatMap({_ in
                    ImageLoader.shared.load(Url: Model.icon!).map({_ in Just(Model)})
                })
                .sink(receiveValue: { (mo) in
                    promise(.success(Model))
                })
                .store(in: &self.cancellable)
        }
    }
            
    func loadPokemonData() {
        
        let mosToInstall = self.manager.retrievePokemon(Rang: self.rang).filter({!$0.isInstalled}).sorted(by: {$0.id < $1.id})
        
        guard !mosToInstall.isEmpty else {
                self.finish()
            return
        }
        
        mosToInstall.map{self.toFuture(Model: $0)}.publisher
            .flatMap(maxPublishers: .max(1)){$0}
            .receive(on: RunLoop.main)
            .sink { (comp) in
                
                switch comp {
                case .finished:
                    self.finish()
                    self.manager.save()
                default: break
                }
            } receiveValue: { (mo) in
                self.message = "Get \(mo.name ?? "")"
                mo.checkIfInstalled()
            }.store(in: &cancellable)
    }
}
