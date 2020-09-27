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

protocol PokemonDetailProtocol {
    
    var name: String {get}
    var infos: String {get}
    var image: UIImage {get}
    var color: Color {get}
    var isLoaded : Bool {get}
    var couldSwap :Bool {get}
    
    var chartStats: [ChartView.ChartData] {get}
    
    var pokemonAppearAnimationDuration : TimeInterval {get}
    
    func loadImage()
    func swipePrevious()
    func swipeNext()
    
}

final class PokemonDetail : PokemonDetailProtocol, ObservableObject {
    
    @Published private(set) var pokemon : Pokemon
    @Published var isLoaded: Bool = false
    @Published var image: UIImage = UIImage()
    @Published var chartStats: [ChartView.ChartData] = []
    
    private var pokemonManager : PokemonManagerProtocol
    
    init(Pokemon:Pokemon, Manager:PokemonManagerProtocol=DataManager.shared, Image:UIImage?=nil) {
        self.pokemonManager = Manager
        self.pokemon = Pokemon
        self.image = Image ?? UIImage()
        self.chartStats = self.pokemonStats
    }
    
    var couldSwap : Bool = true
    
    func loadImage() {
        
        self.isLoaded = false
        self.image = UIImage()
        self.couldSwap = false
        
        let animationDuration = self.pokemonAppearAnimationDuration

            ImageLoader.shared.load(Url: self.pokemon.sprite) { [weak self] (res) in
                switch res {
                case .success(let img) :
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        self?.isLoaded = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                            self?.image = img
                            self?.chartStats = self?.pokemonStats ?? []
                            self?.couldSwap = true
                        }
                    }
                default: break
                }
            }
    }
    
    var pokemonStats: [ChartView.ChartData] {
        return [
            ChartView.ChartData(key: "HP", value: self.pokemon.stats.hp, maxValue: 255),
            ChartView.ChartData(key: "ATK", value: self.pokemon.stats.atk, maxValue: 255),
            ChartView.ChartData(key: "DEF", value: self.pokemon.stats.def, maxValue: 255),
            ChartView.ChartData(key: "SATK", value: self.pokemon.stats.atkS, maxValue: 255),
            ChartView.ChartData(key: "SDEF", value: self.pokemon.stats.defS, maxValue: 255),
            ChartView.ChartData(key: "SPD", value: self.pokemon.stats.speed, maxValue: 180),
        ]
    }
    
    var pokemonAppearAnimationDuration: TimeInterval {
        return 0.5
    }
    
    var name : String {
        return self.pokemon.name.translate
    }
    
    var infos : String {
        return self.pokemon.desc.translate
    }
    
    var color: Color {
        return pokemon.type1.color
    }
    
    func swipePrevious() {
        if let previous = self.pokemonManager.first(Id: pokemon.id - 1) {
            self.pokemon = previous
            self.loadImage()
        }
    }
    
    func swipeNext() {
        if let next = self.pokemonManager.first(Id: pokemon.id + 1) {
            self.pokemon = next
            self.loadImage()
        }
    }
}

extension Pokemon {
    var typeCount : Int {
        return self.type2 == .none ? 1 : 2
    }
}
