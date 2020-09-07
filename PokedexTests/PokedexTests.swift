//
//  PokedexTests.swift
//  PokedexTests
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
import Combine
import SwiftUI
@testable import Pokedex

class PokedexTests: XCTestCase {
    
    var loader = ImageLoader(session: URLSession.shared)
    var uri = URL(string:"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg")!
    
    struct Item : LoaderItemProtocol {
        var id: String
        var request: URLRequest
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDownloadTask() {
        
        let exp = expectation(description: "Download Task")
                
        let item = Item(id: "1234", request: URLRequest(url: uri))
        
        loader.download(item: item) { (result) in
            switch result {
            case .failure(let error) : XCTFail("Failed download \(error.localizedDescription)")
            case .success(let local): print("Saved at \(local)")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testRetrieve() {
        
        testDownloadTask()
        
        let item = Item(id: "1234", request: URLRequest(url: uri))
        let result = loader.retrieve(item: item)
        
        switch result {
        case .failure(let error): XCTFail("failed with \(error.localizedDescription)")
        case .success(let url): print("Success : \(try! String(contentsOf: url))")
        }
    }
    
    func testDelete() throws {
        
        testDownloadTask()
        
        let item = Item(id: "1234", request: URLRequest(url: uri))
        
        let result = loader.delete(item: item)
        
        switch result {
        case .success(let url): print("Success Delete the \(url)")
        default: break
        }
        
    }
    
    var bag : AnyCancellable?
    
    func testLoad() {
        
        let exp = expectation(description: "Futur")
        
        let item = Item(id: "1234", request: URLRequest(url: uri))
        
        self.bag = loader.load(item: item)
            .sink(receiveCompletion: { _ in
                print("Completed")
                exp.fulfill()
            }, receiveValue: { (image) in
                print("Receive image \(image)")
            })
        
        waitForExpectations(timeout: 30) { (err) in
            if let error = err {
                XCTFail("failed with \(error.localizedDescription)")
            }
        }
    }
    
}
