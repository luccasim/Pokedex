//
//  DetailView.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel : PokemonDetailViewModel
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    var model : Pokemon
    
    init(model:Pokemon, VM:PokemonDetailViewModel?=nil) {
        self.model = model
        self.viewModel = VM ?? PokemonDetailViewModel(Pokemon: model)
    }
    
    var swipe : some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded({ value in
                if value.translation.width < 0 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(self.viewModel.border)
                    
                    Image(uiImage: self.viewModel.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.height * 0.47, height: geo.size.height * 0.47)
                        .padding(.top, geo.size.height * 0.1)
                    
                    VStack {
                        Text(self.viewModel.name)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding(.top, 30)
                            .animation(.spring(response: 0.0, dampingFraction:0.2))
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        TypeGroup(pokemon: model)                .padding([.leading, .trailing], 30)
                            .padding(.bottom, -10)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.7)
                
                Group {
                    Text(self.viewModel.infos)
                        .frame(width: geo.size.width * 0.9 , alignment: .center)
                        .padding(.top, 30)
                    
                    Spacer()
                }.gesture(swipe)
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear() {
                self.viewModel.loadImage()
            }
        }
    }
}

struct TypeGroup : View {
    
    var pokemon : Pokemon
    
    var body: some View {
        HStack {
            self.body(withType: pokemon.type1)
            Spacer()
            self.body(withType: pokemon.type2)
        }
    }
    
    func body(withType type: Type) -> some View {
        Group {
            if type.isSet {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(type.color)
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1)
                    Text(type.text)
                }
            }
        }
        .frame(width: 100, height: 30, alignment: .center)
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let vm = PokemonDetailViewModel(Pokemon: Pokemon.Fake, Image: UIImage(named: "bulbazor"))
            DetailView(model: Pokemon.Fake,VM: vm)
            .navigationBarHidden(true)
            .navigationBarTitle("Bulbazor")
        }
    }
}
