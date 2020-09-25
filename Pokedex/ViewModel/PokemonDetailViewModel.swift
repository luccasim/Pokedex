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
    
    init(Pokemon:Pokemon, Manager:PokemonManagerProtocol=DataManager.shared, Image:UIImage?=nil) {
        self.pokemonManager = Manager
        self.pokemon = Pokemon
        self.image = Image ?? UIImage()
    }
    
    @Published var image: UIImage = UIImage()
    
    func loadImage() {
        ImageLoader.shared.load(Url: self.pokemon.sprite) { [weak self] (res) in
            switch res {
            case .success(let img) : DispatchQueue.main.async {
                self?.image = img
            }
            default: break
            }
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
