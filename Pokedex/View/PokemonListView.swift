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
    
    var addPokemonButton : some View {
        Button(action: {
            //action
            self.isPresented.toggle()
        }) {
            Text("+")
        }
    }
        
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(self.viewModel.pokemons) { (Pokemon) in
                    NavigationLink(destination: PokemonDetailView(model: Pokemon)) {
                        Text(Pokemon.name!)
                    }
                }
            }
            .navigationBarTitle(self.viewModel.title)
            .navigationBarItems(trailing: self.addPokemonButton)
            .sheet(isPresented: $isPresented, onDismiss: {
                self.viewModel.fetchPokemon()
            }, content: {
                PokemonAddView()
                })
            .onAppear() {
                self.viewModel.fetchPokemon()
            }
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
        PokemonListView_Previews.listView
    }
}
