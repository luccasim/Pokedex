//
//  LoadingView.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    @ObservedObject var viewModel = LoadingVM()
    
    init() {
        self.viewModel.loadPokemonData()
    }
    
    @State var isLoaded = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {

                Spacer()

                if self.viewModel.isLoaded {
                    NavigationLink(destination: ListView()) {
                        Text(self.viewModel.message)
                    }.padding(.bottom, 10)
                }
                    
                else {
                    Text(self.viewModel.message)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

struct PokemonLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
