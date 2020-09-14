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
    
    init(model:Pokemon) {
        self.model = model
        self.viewModel.set(Pokemon: model)
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
                    .border(Color.green, width: 2)
                    .padding(.bottom, 15)
                HStack {
                    TypeText(text: "Type 1", color: .green)
                    Spacer()
                    TypeText(text: "Type 2", color: .purple)
                }
                .padding([.leading, .trailing], 30)
                
                Text(self.viewModel.infos)
                    .frame(width: geo.size.width * 0.9 , alignment: .center)
                    .padding(.top, 20)
                Spacer()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct TypeText : View {
    
    let text : String
    let color : Color
    
    var body: some View {
        Text(self.text)
            .frame(width: 100, height: 30, alignment: .center)
            .background(self.color)
            .font(.body)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
    }
}


struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetailView(model: FakePokemonManager().fetchToList()[1])
            .navigationBarHidden(true)
            .navigationBarTitle("Bulbazor")
        }
    }
}
