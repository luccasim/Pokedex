//
//  PokemonAddView.swift
//  Pokedex
//
//  Created by owee on 03/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct PokemonAddView: View {
    
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var keyboard = KeyboardResponder()
    
    var viewModel = PokemonAddViewModel()
    
    @State var input : String = ""
    
    var validButton : some View {
        Button(action: {
            if !self.input.isEmpty {
                self.viewModel.add(PokemonName: self.input)
                self.mode.wrappedValue.dismiss()
            }
        }) {
            Text("Add")
        }
    }
    
    var body: some View {
        VStack {
            Text("Top")
            Spacer()
            TextField("Name", text: self.$input)
            Spacer()
            self.validButton
        }
        .padding()
        .padding(.bottom, self.keyboard.currentHeight)
        .animation(.easeOut(duration: self.keyboard.duration))
    }
    
}

struct PokemonAddView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonAddView()
    }
}
