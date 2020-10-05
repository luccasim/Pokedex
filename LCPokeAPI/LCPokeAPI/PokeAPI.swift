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

public final class PokeAPI : PokeAPIProtocol {
    
    let session : URLSession
    
    public init(Session:URLSession=URLSession.shared) {
        self.session = Session
    }
    
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
        
        self.session.dataTask(with: Request) { (Data, Rep, Err) in
            
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

public extension PokeAPI {

    struct PokemonReponse : Codable {
        
        public let name : String
        public let id, base_experience, height, order, weight : Int
        public let sprites : Sprite
        public let species : Specie
        public let types : [Types]
        public let stats : [Stats]
        
        public struct Stats : Codable {
            
            public let base_stat, effort : Int
            public let stat : Stat
            
            public struct Stat : Codable {
                public let name, url : String
            }
        }
        
        public struct Sprite : Codable {
            
            public let back_default : String?
            public let front_default : String
            public let other : Other
            public let versions : Versions
            
            public struct Versions : Codable {
                public let generation7 : Generation
                
                enum CodingKeys : String, CodingKey {
                    case generation7 = "generation-vii"
                }
                
                public struct Generation : Codable {
                    public let icon : Icon
                    public let usul : UsUl
                    
                    enum CodingKeys : String, CodingKey {
                        case icon = "icons"
                        case usul = "ultra-sun-ultra-moon"
                    }
                    
                    public struct Icon : Codable {
                        public let front_default : String?
                    }
                    
                    public struct UsUl : Codable {
                        public let front_default : String?
                    }
                }
            }
            
            public struct Other : Codable {
                public let dream : Dream
                public let official : Official
                
                enum CodingKeys : String, CodingKey {
                    case dream = "dream_world"
                    case official = "official-artwork"
                }
                
                public struct Dream : Codable {
                    public let front_default, front_female : String?
                }
                public struct Official : Codable {
                    public let front_default : String?
                }
            }
        }
        public struct Specie : Codable {
            public let url : String
        }
        public struct Types : Codable {
            public let slot : Int
            public let type : Typee
            public struct Typee : Codable {
                public let url : String
            }
        }
    }
    
    func pokemonGetTask(Id:Int, Callback:@escaping (Result<PokemonReponse,Error>) -> Void) {

        guard let request = Endpoint.Pokemon(Id: Id).request else {
            return Callback(.failure(APIErrors.invalidRequest))
        }
        
        self.task(Request: request, Completion: Callback)
    }
    
    struct SpeciesReponse : Codable {
        
        public let id, order, happiness, captureRate : Int
        public let name : String
        public let text : [Text]
        public let names : [Name]
        
        enum CodingKeys : String, CodingKey {
            case id, order, name, names
            case happiness = "base_happiness"
            case captureRate = "capture_rate"
            case text = "flavor_text_entries"
        }
        
        public struct Text : Codable {
            
            public let flavor_text : String
            public let language : Language
            public let version : Version
            
            public struct Language : Codable {
                public let name, url : String
            }
            
            public struct Version : Codable {
                public let name, url : String
            }
        }
        
        public struct Name : Codable {
            public let name : String
            public let language : Language
            
            public struct Language : Codable {
                public let name, url : String
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
    
    struct TypeReponse : Codable {
        
        public let id : Int
        public let name : String
        public let names : [Name]
        
        public struct Name : Codable {
            public let name : String
            public let language : Language
            
            public struct Language : Codable {
                public let name, url : String
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
