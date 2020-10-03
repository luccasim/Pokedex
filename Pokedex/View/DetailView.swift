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
                
                let distX = abs(value.location.x - value.startLocation.x)
                let distY = abs(value.location.y - value.startLocation.y)
                                
                if value.location.x - value.startLocation.x < 0 && distX > 100 && self.viewModel.couldSwap {
                    self.viewModel.swipeNext()
                }
                
                if value.location.x - value.startLocation.x > 0 && distX > 100 && self.viewModel.couldSwap {
                    self.viewModel.swipePrevious()
                }

                if value.location.y - value.startLocation.y < 0 && distY > 100 {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {

                self.viewModel.color
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 40)
                        .foregroundColor(.white)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .overlay(DisplayView(size: geo.size).environmentObject(self.viewModel))
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

struct DisplayView : View {
    
    @EnvironmentObject var details : PokemonDetail
    let size : CGSize
    
    @State private var showStats = false
    
    var body: some View {
        
        Group {
            
            ZStack {
                
                Circle()
                    .opacity(0.2)
                    .blur(radius: 3.0)
                    .foregroundColor(.white)
                    .scaleEffect(self.details.isLoaded ? 1.1 : 0)
                    .animation(.easeOut(duration:self.details.pokemonAppearAnimationDuration))
                
                Image(uiImage: self.details.image)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(self.details.couldSwap ? 1 : 0.5)
                    .animation(.spring(dampingFraction: 0.5, blendDuration: 3))
                
            }
            .frame(width: 250, height: 250)
            
            Text(self.details.name)
                .font(.largeTitle)
                .padding(.top, -20)
            
            TypeGroup(pokemon: self.details.pokemon)
            
                
            if size.height > 647 {

                InfoGroup(title: self.details.infoTitle, info: self.details.infos, height: 80)
                    .frame(width: size.width * 0.9, height: 180, alignment: .center)
                    .padding(.top, -10)
                
                ChartView(title: self.details.statsTitle, data: self.details.chartStats, color: self.details.color, height: 20)
                    .padding(.horizontal, 20)
                    .padding(.top, -10)
                
            } else {
                
                ZStack {
                    
                    Group {
                        InfoGroup(title: self.details.infoTitle, info: self.details.infos, height: 100)
                            .opacity(self.showStats ? 0 : 1)
                            .padding(.horizontal, 10)
                    }
                    
                    ChartView(title: self.details.statsTitle, data: self.details.chartStats, color: self.details.color, height: 20)
                        .padding([.leading,.trailing], 20)
                        .opacity(self.showStats ? 1 : 0)
                    
                }
                .frame(height: 256, alignment: .top)
                .onTapGesture(perform: {
                    self.showStats.toggle()
                })
            }
            
            Spacer()
        }
        .foregroundColor(.black)
        .padding(.top, -150)
    }
}

struct InfoGroup : View {
    
    let title : String
    let info : String
    let height : CGFloat
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()
            Text(info)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
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
        }.animation(.easeIn)
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
                        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                        .previewDisplayName("iPhone 8")
            }
            NavigationView {
                let vm = PokemonDetail(Pokemon: Pokemon.Fake, Image: UIImage(named: "bulbazor"))
                DetailView(model: Pokemon.Fake,VM: vm)
                    .environment(\.colorScheme, .dark)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                    .previewDisplayName("iPhone 8")
            }
            
            NavigationView {
                let vm = PokemonDetail(Pokemon: Pokemon.Fake, Image: UIImage(named: "bulbazor"))
                    DetailView(model: Pokemon.Fake,VM: vm)
                        .environment(\.colorScheme, .light)
            }
        }
    }
}
