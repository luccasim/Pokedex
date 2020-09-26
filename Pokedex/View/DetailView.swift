//
//  DetailView.swift
//  Pokedex
//
//  Created by owee on 06/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @ObservedObject var viewModel : PokemonDetail
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    var model : Pokemon
    
    init(model:Pokemon, VM:PokemonDetail?=nil) {
        self.model = model
        self.viewModel = VM ?? PokemonDetail(Pokemon: model)
    }
    
    var swipe : some Gesture {
        DragGesture(minimumDistance: 100)
            .onEnded({ value in
                if value.translation.width > 100 {
                    self.presentationMode.wrappedValue.dismiss()
                }
                if value.translation.height > 100 {
                    self.viewModel.swipePrevious()
                }
                if value.translation.height < 100 {
                    self.viewModel.swipeNext()                }
            })
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {

                self.viewModel.border

                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(.white)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .overlay(
                            Group {
                                ZStack {
                                    Circle()
                                        .opacity(0.2)
                                        .blur(radius: 3.0)
                                        .foregroundColor(.white)
                                        .scaleEffect(self.viewModel.isLoaded ? 1.1 : 0)
                                        .animation(.easeIn(duration:0.7))
                                    Image(uiImage: self.viewModel.image)
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(width: 250, height: 250)
                                Text(self.viewModel.name)
                                    .font(.largeTitle)
                                    .padding(.top, -10)
                                TypeGroup(pokemon: self.viewModel.pokemon).padding()
                                Text(self.viewModel.infos).padding()
                                Spacer()
                            }
                            .foregroundColor(.black)
                            .padding(.top, -150)
                        )
                        .offset(CGSize(width: 0, height: geo.size.width * 0.5))
                        .gesture(swipe)
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea([.top, .horizontal])
            .onAppear() {
                self.viewModel.loadImage()
            }
        }
    }
}

struct TypeGroup : View {
    
    var pokemon : Pokemon
    
    var body: some View {
        HStack(spacing: 50) {
            self.body(withType: pokemon.type1)
            if self.pokemon.typeCount == 2 {
                self.body(withType: pokemon.type2)
            }
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
        Group {
            NavigationView {
                let vm = PokemonDetail(Pokemon: Pokemon.Fake, Image: UIImage(named: "bulbazor"))
                    DetailView(model: Pokemon.Fake,VM: vm)
                        .environment(\.colorScheme, .dark)
            }
            
            NavigationView {
                let vm = PokemonDetail(Pokemon: Pokemon.Fake, Image: UIImage(named: "bulbazor"))
                    DetailView(model: Pokemon.Fake,VM: vm)
                        .environment(\.colorScheme, .light)
            }
        }
    }
}
