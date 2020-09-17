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
    var infos: String {get}
    var image: UIImage {get}
    var border: Color {get}
    
    func loadImage()
    
}

final class PokemonDetailViewModel : PokemonDetailVMProtocol, ObservableObject {
    
    @Published private var pokemon : Pokemon
    private var pokemonManager : PokemonManagerProtocol
    
    init(Pokemon:Pokemon, Manager:PokemonManagerProtocol=PokemonManager.shared) {
        self.pokemonManager = Manager
        self.pokemon = Pokemon
    }
    
    @Published var image: UIImage = UIImage()
    private var cancelLoad : AnyCancellable?
    
    func loadImage() {
        self.cancelLoad = self.pokemonManager.getImage(Pokemon: self.pokemon)
            .receive(on: RunLoop.main)
            .sink { (img) in
                self.image = img
        }
    }
    
    var name : String {
        return self.pokemon.name.translate
    }
    
    var infos : String {
        return self.pokemon.desc.translate
    }
    
    var border: Color {
        return pokemon.type1.color
    }
}
