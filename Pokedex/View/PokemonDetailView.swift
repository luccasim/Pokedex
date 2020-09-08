//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @ObservedObject var viewModel = PokemonDetailViewModel()
    var model : Pokemon
    
    var body: some View {
        VStack {
            Text(self.viewModel.name)
                .font(.largeTitle)
        
            Image(uiImage: self.viewModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .border(Color.green, width: 2)
            Text(self.viewModel.infos)
            Spacer()
            HStack {
                Text("Type 1")
                    .fontWeight(.bold)
                    .background(Color.green)
                    .border(Color.black, width: 2)
                    .cornerRadius(40)
                Spacer()
                Text("Type 2")
                    .padding(.trailing, 50.0)
                    .background(Color.purple)
            }
            .padding(20)
        }
        .padding(10)
        .onAppear {
            self.viewModel.set(Pokemon: self.model)
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetailView(model: FakePokemonManager().fetchToList()[0])
            .navigationBarHidden(true)
            .navigationBarTitle("Bulbazor")
        }
    }
}
