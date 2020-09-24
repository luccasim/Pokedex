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
    @State var pushToListView = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                NavigationLink(
                    destination: ListView(),
                    isActive: self.$pushToListView,
                    label: {
                        EmptyView()
                    }).hidden()
                
                Spacer()
                PokeBall(
                    finishDuration: 2,
                    isLoaded: viewModel.isLoaded,
                    message: viewModel.message
                )
                Button(action: {
                    if viewModel.isLoaded {
                        self.pushToListView = true
                    }
                }, label: {
                    Text(self.viewModel.message)
                        .animation(nil)
                })
                
                Spacer()
                
            }.onAppear() {
                viewModel.loadPokemonData()
            }
        }
        .navigationBarHidden(pushToListView ? false : true)
    }
}

struct PokeBall : View {
    
    let finishDuration : TimeInterval
    let isLoaded : Bool
    let message : String
    
    @State private var rotation = false
    
    var loadAnimation : Animation {
        Animation
            .easeIn(duration: 0.6)
            .delay(0.2)
            .repeatForever(autoreverses: true)
    }
    
    var loadedAnimation :Animation {
        Animation.linear(duration: finishDuration)
    }
    
    var body: some View {
        VStack {
        ZStack {
            
            Image("pokeball")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(rotation ? 20 : -10))
                .animation(isLoaded ? .default : loadAnimation)
                .opacity(isLoaded ? 0 : 1)
            
            Image("done")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(25))
                .opacity(isLoaded ? 1 : 0)
            
        }
        .frame(width: 200, height: 200)
        .scaleEffect(0.8)
        }
        
        .onAppear() {
            self.rotation = true
        }
    }
}

struct PokemonLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
