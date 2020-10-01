//
//  LCPokeAPITests.swift
//  LCPokeAPITests
//
//  Created by owee on 01/10/2020.
//

import XCTest
@testable import LCPokeAPI

class LCPokeAPITests: XCTestCase {

    func testPokemon() throws {
        let data = load(FileName: "Pokemon.json")
        let reponse = try JSONDecoder().decode(PokeAPI.PokemonReponse.self, from: data)
        
        print(reponse)
    }

    func testSpecies() throws {
        
        let data = load(FileName: "Species.json")
        let reponse = try JSONDecoder().decode(PokeAPI.SpeciesReponse.self, from: data)
        
        print(reponse)
    }
    
    func testTypes() throws {
        let data = load(FileName: "Types.json")
        let reponse = try JSONDecoder().decode(PokeAPI.TypeReponse.self, from: data)
        
        print(reponse)
    }
}

extension XCTestCase {
    
    func load(FileName:String) -> Data {
        
        let url = Bundle.main.url(forResource: FileName, withExtension: nil)!
        return try! Data(contentsOf: url)
        
    }
}
