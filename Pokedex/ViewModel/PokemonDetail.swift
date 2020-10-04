//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import AVFoundation
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
    var infoTitle: String {get}
    var statsTitle: String {get}
    
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
    
    private var dataManager : DataManagerInterface
    
    init(Pokemon:Pokemon, Manager:DataManagerInterface?=nil, Image:UIImage?=nil) {
        
        self.dataManager = Manager ?? DataManager.shared
        self.image = Image ?? UIImage()
        self.pokemon = Pokemon
        self.chartStats = self.pokemonStats
        
    }
    
    var couldSwap : Bool = true
    weak var audio : AVAudioPlayer?
    
    func loadImage() {
        
        self.isLoaded = false
        self.image = UIImage()
        self.couldSwap = false
        
        let animationDuration = self.pokemonAppearAnimationDuration
        
        if let url = self.pokemon.audio {
            dataManager.audioLoader.load(Url: url) { [weak self] res in
                switch res {
                case .success(let av): self?.audio = av
                default: break
                }
            }
        }

        dataManager.imageLoader.load(Url: self.pokemon.sprite) { [weak self] (res) in
                switch res {
                case .success(let img) :
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        self?.isLoaded = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                            self?.image = img
                            self?.chartStats = self?.pokemonStats ?? []
                            self?.couldSwap = true
                            self?.audio?.play()
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
    
    var infoTitle: String {
        return NSLocalizedString("Description", comment: "The pokemon text description.")
    }
    
    var statsTitle: String {
        return NSLocalizedString("Stats", comment: "Pokemon stats.")
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
        if let previous = self.dataManager.first(Id: pokemon.id - 1) {
            self.pokemon = previous
            self.loadImage()
        }
    }
    
    func swipeNext() {
        if let next = self.dataManager.first(Id: pokemon.id + 1) {
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
