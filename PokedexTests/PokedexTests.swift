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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTask() {
        
        let ws = WebService(Session: URLSession.shared)
        
        let requests = (1...20)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        print(requests)
        
        let exp = expectation(description: "test ws")
        
        ws.dataTask(Request: requests[0]) { (res) in
            switch res {
            case .failure(let error): XCTFail(error.localizedDescription)
            case .success(let data): print(data)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
        }
    }
    
    func testDownloadListOrder() {
        
        let ws = WebService(Session: URLSession.shared)
        
        let requests = (1...20)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number)")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testDownloadListSimultaneous() {
        
        let ws = WebService(Session: URLSession.shared)
        
        let requests = (1...20)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Simultaneous, List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number)")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    func testDownloadListPage() {
        
        let ws = WebService(Session: URLSession.shared)
        
        let requests = (1...20)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Page(Page: 3), List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number) !")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testDownloadListTimer() {
        
        let ws = WebService(Session: URLSession.shared)
        
        let requests = (1...20)
            .compactMap {URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\($0).png")}
            .map {URLRequest(url: $0)}
        
        let exp = expectation(description: "Download list")
        
        let list = requests + requests
        
        ws.listTask(Option: .Timer(Page: 5, Interval: 10), List: list, Completion: { (res) in
            switch res {
            case .failure(let error): print(error.localizedDescription)
            case .success(let tuple): print("[\(tuple.0.url!)] with \(tuple.1)")
            }
        }) { (Number) in
            print("Success request \(Number) !")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 50, handler: nil)
    }
}

extension Data {
    
    var toString : String {
        return String(data: self, encoding: .utf8) ?? self.description
    }
    
}
