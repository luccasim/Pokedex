//
//  PokeAPI.swift
//  Pokedex
//
//  Created by owee on 13/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol PokeAPIProtocol {
        
    func pokemonGetTask(Id:Int, Callback:@escaping (Result<PokeAPI.PokemonReponse,Error>) -> Void)
    func speciesGetTask(Id:Int, Callback:@escaping (Result<PokeAPI.SpeciesReponse,Error>) -> Void)
    func typeGetTask(Id:Int, CallBack:@escaping (Result<PokeAPI.TypeReponse,Error>) -> Void)
    
}

final class PokeAPI : PokeAPIProtocol {
    
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
    
    func task<Reponse:Codable>(Request:URLRequest, Completion:@escaping (Result<Reponse,Error>) -> Void) {
        
        URLSession.shared.dataTask(with: Request) { (Data, Rep, Err) in
            
            if let error = Err {
                return Completion(.failure(error))
            }
            
            else if let data = Data {
                
                do {
                    
                    let reponse = try JSONDecoder().decode(Reponse.self, from: data)
                    Completion(.success(reponse))
                    
                } catch let error  {
                    Completion(.failure(error))
                }
            }
            
        }.resume()
    }
}

extension PokeAPI {

    struct PokemonReponse : Codable {
        
        let name : String
        let id, base_experience, height, order, weight : Int
        let sprites : Sprite
        let species : Specie
        let types : [Types]
        let stats : [Stats]
        
        struct Stats : Codable {
            
            let base_stat, effort : Int
            let stat : Stat
            
            struct Stat : Codable {
                let name, url : String
            }
        }
        
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
    
    func pokemonGetTask(Id:Int, Callback:@escaping (Result<PokemonReponse,Error>) -> Void) {

        guard let request = Endpoint.Pokemon(Id: Id).request else {
            return Callback(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: Callback)
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
    
    func speciesGetTask(Id:Int, Callback: @escaping (Result<SpeciesReponse,Error>) -> Void) {
        
        let endpoint = Endpoint.Species(Id: Id)
        
        guard let request = endpoint.request else {
            return Callback(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: Callback)
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
    
    func typeGetTask(Id:Int, CallBack: @escaping (Result<TypeReponse,Error>) -> Void) {
        
        let endpoint = Endpoint.Types(Id: Id)
        
        guard let request = endpoint.request else {
            return CallBack(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: CallBack)
    }
}
