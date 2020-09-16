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
                    TypeText(type: self.model.type1)
                    Spacer()
                    TypeText(type: self.model.type2)
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
    
    let type : Type
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(self.type.color)
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1)
            Text(self.type.text)
        }
        .frame(width: 100, height: 30, alignment: .center)
        .foregroundColor(Color.black)
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
