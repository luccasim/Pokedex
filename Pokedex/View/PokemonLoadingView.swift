//
//  PokemonLoadingView.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct PokemonLoadingView: View {
    
    @ObservedObject var viewModel = PokemonLoadingViewModel()
    
    init() {
        self.viewModel.loadPokemonData()
    }
    
    @State var isLoaded = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: PokemonListView(), isActive: $isLoaded) {
                    Text("Continue")
                }
                Spacer()
                
                Text(self.viewModel.message)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct PokemonLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonLoadingView()
    }
}
