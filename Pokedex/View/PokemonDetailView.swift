//
//  DetailView.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel : PokemonDetailViewModel
    var model : Pokemon
    
    init(model:Pokemon) {
        self.model = model
        self.viewModel = PokemonDetailViewModel(Pokemon: model)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                Text(self.viewModel.name)
                    .font(.largeTitle)
                    .padding(.top, 25)
                
                Image(uiImage: self.viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                    .border(self.viewModel.border, width: 2)
                    .padding(.bottom, 15)
                
                TypeGroup(pokemon: model)

                .padding([.leading, .trailing], 30)
                
                Text(self.viewModel.infos)
                    .frame(width: geo.size.width * 0.9 , alignment: .center)
                    .padding(.top, 20)
                Spacer()
            }
            .navigationBarHidden(false)
            .edgesIgnoringSafeArea(.top)
            .onAppear() {
                self.viewModel.loadImage()
            }
        }
    }
}

struct TypeGroup : View {
    
    var pokemon : Pokemon
    
    var body: some View {
        HStack {
            self.body(withType: pokemon.type1)
            Spacer()
            self.body(withType: pokemon.type2)
        }
    }
    
    func body(withType type: Type) -> some View {
        Group {
            if type.isSet {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(type.color)
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1)
                    Text(type.text)
                }
            }
        }
        .frame(width: 100, height: 30, alignment: .center)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(model: Pokemon.Fake)
            .navigationBarHidden(true)
            .navigationBarTitle("Bulbazor")
        }
    }
}
