//
//  TranslatorTests.swift
//  PokedexTests
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
@testable import Pokedex

class TranslatorTests: XCTestCase {

    func testGetLangs() {
        
        let translator = Translator()
        
        print("Lang : \(translator.langs)")
        XCTAssert(translator.langs.count == 1)

        translator.set(NewLang: "fr")
        print("Lang : \(translator.langs)")
        XCTAssert(translator.langs.count == 2)
        
        translator.set(NewLang: "en")
        print("Lang : \(translator.langs)")
        XCTAssert(translator.langs.count == 2)
    }
    
    func testGetKeys() {
        
        let translator = Translator.shared
        
        print("Keys : \(translator.getKeys(Lang: "en"))")
        XCTAssert(translator.getKeys(Lang: "en").count == 0)

    }
    
    func testTranslate() {
        
        let translator = Translator.shared
        
        translator.set(Key: "desc", NewText: "Hello World", ForLang: "en")
        print("Keys : \(translator.getKeys(Lang: "en"))")
        
        XCTAssert("desc".translate == "Hello World")
        
        translator.set(Key: "desc", NewText: "Bonjour", ForLang: "fr")
        print("Keys : \(translator.getKeys(Lang: "fr"))")
        
        translator.select(Lang: "fr")
        XCTAssert("desc".translate == "Bonjour")
        
    }
}
