//
//  PokeAPI.swift
//  Pokedex
//
//  Created by owee on 13/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import LCFramework
import Combine

protocol PokeAPIProtocol {
    
    func installPokemon(Models:[PokeAPIModel]) -> Future<[PokeAPIModel],Never>
    
}

protocol PokeAPIModel {
    
    var pokemonID : Int {get}
    var typeId1 : String? {get set}
    var typeId2 : String? {get set}
    
    func setPokemon(Reponse:PokeAPI.PokemonReponse)
    func setSpecies(Reponse:PokeAPI.SpeciesReponse)
    func setTypes(Reponse:PokeAPI.TypeReponse)
    
}

final class PokeAPI : WebService, PokeAPIProtocol {
    
    enum APIErrors : Error {
        case invalidRequest
    }
    
    enum Endpoint {
        
        case Pokemon(Id:Int)
        case Species(Id:Int)
        case Types(Id:Int)
        
        fileprivate var request : URLRequest? {
            
            switch self {
                
            case .Pokemon(Id: let id):
                
                let path = "https://pokeapi.co/api/v2/pokemon/\(id)/"
                guard let url = URLComponents(string: path)?.url else { return nil }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
                
            case .Species(Id: let id):
                
                let path = "https://pokeapi.co/api/v2/pokemon-species/\(id)/"
                guard let url = URLComponents(string: path)?.url else { return nil}
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
                
            case .Types(Id: let id):
                
                let path = "https://pokeapi.co/api/v2/type/\(id)/"
                guard let url = URLComponents(string: path)?.url else { return nil}
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
                
            }
        }
    }
    
    var cancel = Set<AnyCancellable>()
    
    func installPokemon(Models: [PokeAPIModel]) -> Future<[PokeAPIModel],Never> {
        return Future<[PokeAPIModel],Never> { promise in

        Models.publisher
            .map({self.modelTasks(Model: $0)})
            .flatMap(maxPublishers: .max(1)){$0}
            .sink(receiveCompletion: { (finish) in
                promise(.success(Models))
            }) { (model) in
                print("Finish \(model)")
            }
            .store(in: &self.cancel)
        }
    }
    
    func modelTasks(Model:PokeAPIModel) -> AnyPublisher<PokeAPIModel,Never> {
        return self.pokemonFuture(Model: Model)
            .flatMap { model in
                self.speciesFuture(Model: model)
            }.flatMap { model in
                self.typeFuture(Model: model)
            }.catch { Error in
                Just(Model)
            }.eraseToAnyPublisher()
    }
}

extension PokeAPI {

    struct PokemonReponse : Codable {
        
        let name : String
        let id, base_experience, height, order, weight : Int
        let sprites : Sprite
        let species : Specie
        let types : [Types]
        
        struct Sprite : Codable {
            
            let back_default, front_default : String
            let other : Other
            
            struct Other : Codable {
                let dream : Dream
                let official : Official
                
                enum CodingKeys : String, CodingKey {
                    case dream = "dream_world"
                    case official = "official-artwork"
                }
                
                struct Dream : Codable {
                    let front_default, front_female : String?
                }
                struct Official : Codable {
                    let front_default : String
                }
            }
        }
        struct Specie : Codable {
            let url : String
        }
        struct Types : Codable {
            let slot : Int
            let type : Typee
            struct Typee : Codable {
                let url : String
            }
        }
    }
    
    func pokemonFuture(Model:PokeAPIModel) -> Future<PokeAPIModel,Error> {
        return Future<PokeAPIModel,Error> { promise in
            
            guard let request = Endpoint.Pokemon(Id: Model.pokemonID).request else {
                return promise(.failure(APIErrors.invalidRequest))
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: RunLoop.main)
                .map({$0.data})
                .decode(type: PokemonReponse.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { (comp) in
                    switch comp {
                    case .failure(let error): promise(.failure(error))
                    default: break
                    }
                }) { (reponse) in
                    Model.setPokemon(Reponse: reponse)
                    print("Success set PokemonReponse to \(reponse.name)")
                    promise(.success(Model))
            }.store(in: &self.cancel)
        }
    }
}

extension PokeAPI {
    
    struct SpeciesReponse : Codable {
        
        let id, order, happiness, captureRate : Int
        let name : String
        let text : [Text]
        let names : [Name]
        
        enum CodingKeys : String, CodingKey {
            case id, order, name, names
            case happiness = "base_happiness"
            case captureRate = "capture_rate"
            case text = "flavor_text_entries"
        }
        
        struct Text : Codable {
            
            let flavor_text : String
            let language : Language
            let version : Version
            
            struct Language : Codable {
                let name, url : String
            }
            
            struct Version : Codable {
                let name, url : String
            }
        }
        struct Name : Codable {
            let name : String
            let language : Language
            
            struct Language : Codable {
                let name, url : String
            }
        }
    }
    
    func speciesFuture(Model:PokeAPIModel) -> Future<PokeAPIModel,Error> {
        return Future<PokeAPIModel,Error> { promise in
            
            guard let request = Endpoint.Species(Id: Model.pokemonID).request else {
                return promise(.failure(APIErrors.invalidRequest))
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .map({$0.data})
                .decode(type: SpeciesReponse.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (comp) in
                    switch comp {
                    case .failure(let error): promise(.failure(error))
                    default: break
                    }
                }) { (reponse) in
                    Model.setSpecies(Reponse: reponse)
                    print("Success set Species to \(reponse.name)")
                    promise(.success(Model))
            }.store(in: &self.cancel)
        }
    }
}

extension PokeAPI {
    
    struct TypeReponse : Codable {
        let id : Int
        let name : String
        let names : [Name]
        
        struct Name : Codable {
            let name : String
            let language : Language
            
            struct Language : Codable {
                let name, url : String
            }
        }
    }
    
    private func typeTask(Model:PokeAPIModel, Request:URL?) -> Future<TypeReponse, Error> {
        return Future<TypeReponse,Error> { promise in
            
            guard let request = Request else {
                return promise(.failure(APIErrors.invalidRequest))
            }
            
            URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: RunLoop.main)
                .map{$0.data}
                .decode(type: TypeReponse.self, decoder: JSONDecoder())
                .sink(receiveCompletion: {compl in
                    switch compl {
                    case .failure(let error): promise(.failure(error))
                    default: break
                    }
                }) { (reponse) in
                    Model.setTypes(Reponse: reponse)
                    promise(.success(reponse))
            }.store(in: &self.cancel)
        }
    }
    
    func typeFuture(Model:PokeAPIModel) -> Future<PokeAPIModel,Error> {
        return Future<PokeAPIModel,Error> { promise in
            
            let request1 = Model.typeId1.flatMap({URL(string: $0)})
            let request2 = Model.typeId2.flatMap({URL(string: $0)})
            
            let p1 = self.typeTask(Model: Model, Request: request1)
            let p2 = self.typeTask(Model: Model, Request: request2)
            
            Publishers.Zip(p1, p2)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (compl) in
                    promise(.success(Model))
                }) { (reponses) in
                    print("Success set Type to \(Model.pokemonID)")
            }.store(in: &self.cancel)
        }
    }
}
