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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPokemonAPICall() throws {
        
        let ws = PokeAPI()
        
        let exp = expectation(description: "Call API")
        var reponse : PokeAPI.PokemonReponse?
        
        ws.taskPokemon(Endpoint: .Pokemon(Id: 120)) { (res) in
            switch res {
            case .failure(let err) : XCTFail(err.localizedDescription)
            case .success(let rep) : reponse = rep
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
        if let rep = reponse {
            print(rep)
        }
    }

    func testSpecies() throws {
        
        let data = load(FileName: "Species.json")
        let reponse = try JSONDecoder().decode(PokeAPI.SpeciesReponse.self, from: data)
        
        print(reponse)
    }
}

extension XCTestCase {
    
    func load(FileName:String) -> Data {
        
        let url = Bundle.main.url(forResource: FileName, withExtension: nil)!
        return try! Data(contentsOf: url)
        
    }
}
