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
    func taskPokemon(Endpoint:PokeAPI.Endpoint, Completion:@escaping(Result<PokeAPI.PokemonReponse,Error>)->Void)
}

final class PokeAPI : WebService {
    
    enum APIErrors : Error {
        case invalidRequest
    }
    
    enum Endpoint {
        
        case Pokemon(Id:Int)
        
        fileprivate var request : URLRequest? {
            
            switch self {
                
            case .Pokemon(Id: let id):
                
                let path = "https://pokeapi.co/api/v2/pokemon/\(id)/"
                guard let url = URLComponents(string: path)?.url else { return nil }
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

extension PokeAPI : PokeAPIProtocol {
    
    struct PokemonReponse : Codable {
        
        let name : String
        let base_experience, height, order, weight : Int
        let sprites : Sprite
        let species : Specie
        
        struct Sprite : Codable {
            let back_default : String
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
