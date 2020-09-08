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

final class PokemonDetailViewModel : PokemonDetailVMProtocol, ObservableObject {
    
    @Published private var pokemon : Pokemon?
    private let loader = ImageLoader.shared
    
    @Published var image: UIImage = UIImage()
    var cancellable : AnyCancellable?
    
    func set(Pokemon:Pokemon) {
        self.pokemon = Pokemon
        self.loadImage(Pokemon: Pokemon)
    }
    
    func loadImage(Pokemon:Pokemon) {
        self.cancellable = self.loader.load(Item: Pokemon.item)
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] in self?.image = $0})
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
