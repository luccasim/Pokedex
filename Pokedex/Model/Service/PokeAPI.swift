//
//  PokeAPI.swift
//  Pokedex
//
//  Created by owee on 13/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import LCFramework

protocol PokeAPIProtocol {
    
    func installPokemon(Ids:[Int], Completion:@escaping(Result<([PokeAPI.SpeciesReponse],[PokeAPI.PokemonReponse]),Never>)->Void)
    
    func taskPokemon(Endpoint:PokeAPI.Endpoint, Completion:@escaping(Result<PokeAPI.PokemonReponse,Error>)->Void)
    func taskSpecies(Endpoint:PokeAPI.Endpoint, Completion:@escaping(Result<PokeAPI.SpeciesReponse,Error>)->Void)

}

final class PokeAPI : WebService, PokeAPIProtocol {
    
    enum APIErrors : Error {
        case invalidRequest
    }
    
    enum Endpoint {
        
        case Pokemon(Id:Int)
        case Species(Id:Int)
        
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
            }
        }
    }
    
    func installPokemon(Ids: [Int], Completion: @escaping (Result<([SpeciesReponse],[PokemonReponse]), Never>) -> Void) {
        
        let requests = Ids.compactMap({Endpoint.Species(Id: $0).request})
        var species : [SpeciesReponse] = []
        var pokemons : [PokemonReponse] = []
        
        self.listTask(List: requests, Completion: { result in
            
            switch result {
            case .success(let tutle):
                if let reponse = try? JSONDecoder().decode(SpeciesReponse.self, from: tutle.1) {
                    species.append(reponse)
                }
            default: break
            }
            
        }) { (success) in
            
            let pokemonsRequest = Ids.compactMap({Endpoint.Pokemon(Id: $0).request})
            self.listTask(List: pokemonsRequest, Completion: { (pokemonResult) in
                switch pokemonResult {
                case .success(let tuple):
                    if let reponse = try? JSONDecoder().decode(PokemonReponse.self, from: tuple.1) {
                        pokemons.append(reponse)
                    }
                default:break
                }
            }) { (success) in
                Completion(.success((species, pokemons)))
            }
        }
    }
    
}

extension PokeAPI {

    struct PokemonReponse : Codable {
        
        let name : String
        let id, base_experience, height, order, weight : Int
        let sprites : Sprite
        let species : Specie
        
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
    }
    
    func taskPokemon(Endpoint:Endpoint, Completion:@escaping(Result<PokemonReponse,Error>) -> Void) {
        
        guard let request = Endpoint.request else {
            return Completion(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: Completion)
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
    
    func taskSpecies(Endpoint:Endpoint, Completion:@escaping(Result<SpeciesReponse,Error>) -> Void) {
        
        guard let request = Endpoint.request else {
            return Completion(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: Completion)
    }
}
