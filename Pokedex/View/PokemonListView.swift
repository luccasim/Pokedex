//
//  PokemonListView.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct PokemonListView: View {
    
    @ObservedObject var viewModel = PokemonListViewModel()
    
    @State var isPresented = false
        
    var body: some View {
        
        VStack {
            
            List {
                
                ForEach(self.viewModel.pokemons) { (Pokemon) in
                    NavigationLink(destination: PokemonDetailView(model: Pokemon)) {
                        PokemonListCell(Pokemon: Pokemon)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle(self.viewModel.title)
            .onAppear() {
                self.viewModel.fetchPokemon()
            }
        }
    }
}

struct PokemonListCell : View {
    
    @ObservedObject var viewModel : PokemonListCellViewModel
    
    init(Pokemon:Pokemon) {
        self.viewModel = PokemonListCellViewModel(Pokemon: Pokemon)
        self.viewModel.loadImage()
    }
    
    var body: some View {
        HStack {
            Image(uiImage: viewModel.image)
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(10)
            Text("No.\(self.viewModel.id) \(self.viewModel.name)")
            Spacer()
        }
        .padding([.trailing, .leading], 10)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            PokemonListCell(Pokemon: Pokemon.Fake).previewLayout(.fixed(width: 350, height: 45))
            PokemonListView()
        }
    }
}
