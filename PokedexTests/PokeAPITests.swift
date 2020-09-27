//
//  PokeAPITests.swift
//  PokedexTests
//
//  Created by owee on 13/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
@testable import Pokedex

class PokeAPITests: XCTestCase {
    
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
