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
            
            Button(action: {
                if viewModel.isLoaded {
                    self.pushToListView = true
                }
            }, label: {
                PokeBall(
                    finishDuration: 2,
                    isLoaded: viewModel.isLoaded,
                    message: viewModel.message
                )
                .padding(.bottom, 20)
            })
            
            Spacer()
            
        }.onAppear() {
            viewModel.loadPokemonData()
        }
    }
    }
}

struct PokeBall : View {
    
    let finishDuration : TimeInterval
    let isLoaded : Bool
    let message : String
    
    @State private var rotation = false
    
    var loadAnimation : Animation {
        Animation.easeIn(duration: 0.3).repeatForever(autoreverses: true)
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
                .rotationEffect(.degrees(rotation ? 45 : -10))
                .animation(isLoaded ? loadedAnimation : loadAnimation)
                .opacity(isLoaded ? 0 : 1)
            
            Image("done")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(30))
                .opacity(isLoaded ? 1 : 0)
            
        }
        .frame(width: 200, height: 200)
        .scaleEffect(0.8)
            Text(message)
                .animation(nil)
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
