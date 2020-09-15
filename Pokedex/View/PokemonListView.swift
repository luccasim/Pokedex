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
                        Text(Pokemon.name!.translate).frame(height: 30)
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
    var body: some View {
        HStack {
            Image("circle")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
            Text("No. \(1)")
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    
    static var listView : PokemonListView {
        var view = PokemonListView()
        view.viewModel = PokemonListViewModel(Manager:FakePokemonManager())
        return view
    }
    
    static var previews: some View {
        NavigationView {
            PokemonListView_Previews.listView
        }
    }
}
