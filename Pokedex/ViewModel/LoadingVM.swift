//
//  PokemonLoadingViewModel.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import AVFoundation
import Foundation
import Combine
import LCFramework
import LCPokeAPI

protocol PokemonLoadingViewModelProtocol {
    
    var isLoaded : Bool {get}
    var message : String {get}
    
    func loadPokemonData()
}

final class LoadingVM : ObservableObject, PokemonLoadingViewModelProtocol {
    
    @Published var isLoaded = false
    @Published var message: String
    
    private var manager : DataManagerInterface
    private let configM = ConfigManager.shared
    private let pokeapiWS = PokeAPI()
    
    private var cancellable = Set<AnyCancellable>()
    
    init(Manager:DataManagerInterface?=nil) {
        
        self.manager = Manager ?? DataManager.shared
        self.message = NSLocalizedString("Loading", comment: "Message when app load pokemon models.")
                
        if ConfigManager.shared.resetDatabase {
            self.manager.resetData()
        }
    }
    
    private func finish() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + configM.loadingTime) {
            self.isLoaded = true
            self.message = NSLocalizedString("Enter", comment: "Press to Continue")
            self.manager.loadTranslation()
        }
    }
            
    func loadPokemonData() {
        
        let mosToInstall = self.manager.retrievePokemon(Rang: configM.generationRang).filter({!$0.isInstalled}).sorted(by: {$0.id < $1.id})
        
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
                mo.checkIfInstalled()
            }
            .store(in: &cancellable)
    }
    
    private func toFuture(Model:PokemonMO) -> Future<PokemonMO, Never> {
        return Future<PokemonMO,Never> { promise in
            
            self.pokemonFuture(Model: Model)
                .receive(on: RunLoop.main)
                .flatMap({_ in self.speciesFuture(Model: Model)})
                .flatMap({_ in self.typeFuture(Model: Model, ID: Model.idType1)})
                .flatMap({_ in self.typeFuture(Model: Model, ID: Model.idType2)})
                .flatMap({_ in self.iconFuture(Model: Model)})
                .catch {_ in Just(Model)}
                .sink(receiveValue: { (mo) in
                    promise(.success(Model))
                })
                .store(in: &self.cancellable)
        }
    }
    
    private func pokemonFuture(Model:PokemonMO) -> Future<PokemonMO, Error> {
        return Future<PokemonMO,Error> { promise in
            
            self.pokeapiWS.pokemonGetTask(Id: Int(Model.id), Callback: { (result) in
                switch result {
                case .success(let reponse):
                    DispatchQueue.main.async {Model.setPokemon(Reponse: reponse)}
                default: break
                }
                promise(.success(Model))
            })
        }
    }
    
    private func speciesFuture(Model:PokemonMO) -> Future<PokemonMO, Error> {
        return Future<PokemonMO, Error> { promise in
            
            let id = Int(Model.id)
            self.pokeapiWS.speciesGetTask(Id: id) { (result) in
                switch result {
                case .success(let reponse):
                    DispatchQueue.main.async {
                        Model.setSpecies(Reponse: reponse)
                    }
                default: break
                }
                promise(.success(Model))
            }
        }
    }
    
    enum VMError : Error {
        case noTypeId
        case iconURLnotSet
    }
    
    private func typeFuture(Model:PokemonMO, ID:Int?) -> Future<PokemonMO, Error> {
        return Future<PokemonMO, Error> { promise in
            
            guard let id = ID else {
                return promise(.failure(VMError.noTypeId))
            }
            
            self.pokeapiWS.typeGetTask(Id: id) { (result) in
                switch result {
                case .success(let reponse):
                    DispatchQueue.main.async {
                        Model.setTypes(Reponse: reponse)
                    }
                default: break
                }
                promise(.success(Model))
            }
        }
    }
    
    private func iconFuture(Model:PokemonMO) -> Future<PokemonMO, Error> {
        return Future<PokemonMO, Error> { promise in
            
            guard let url = Model.icon else {
                return promise(.failure(VMError.iconURLnotSet))
            }
            
            ImageLoader.shared.load(Url: url) { (res) in
                DispatchQueue.main.async {
                    switch res {
                    case .success(_): promise(.success(Model))
                    case .failure(let error): promise(.failure(error))
                    }
                }
            }
        }
    }
    
}
