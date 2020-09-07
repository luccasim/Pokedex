//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

protocol PokemonDetailVMProtocol {
    
    var name: String {get}
    var imageName : String {get}
    var infos : String {get}
        
    var image : UIImage {get}
}

let Cloader = ImageLoader(session: URLSession.shared)

final class PokemonDetailViewModel : PokemonDetailVMProtocol, ObservableObject {
    
    @Published private var pokemon : Pokemon?
    private let loader = Cloader
    
    @Published var image: UIImage = UIImage()
    
    var cancellable : AnyCancellable?
    
    func set(Pokemon:Pokemon) {
        self.pokemon = Pokemon
        self.loadImage()
    }
    
    func loadImage() {
        
        let request = URLRequest(url: URL(string: "https://wallpaperaccess.com/download/8k-beach-2053958")!)
        let item = ImageLoader.ImageItem(fileName: "bulbazor", request: request)
        
        self.cancellable = self.loader.load(item: item)
            .receive(on: RunLoop.main)
            .sink(receiveValue: {self.image = $0})
    }
    
    var name : String {
        return self.pokemon?.name ?? "404"
    }
    
    var imageName: String {
        return self.pokemon?.sprite ?? "404"
    }
    
    var infos : String {
        return self.pokemon?.desc ?? "404"
    }
    
}
