//
//  HelperTests.swift
//  HelperTests
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
import Combine
@testable import Helper


class HelperTests: XCTestCase {
    
    var loader = ImageLoader()

    var url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"
    
    var bag = Set<AnyCancellable>()
    
    func testDownloadTask() {
        
        let url = URL(string: url)!
        
        self.bag = URLSession.shared.downloadTask(with: url)
            .map{}
        
    }

}
