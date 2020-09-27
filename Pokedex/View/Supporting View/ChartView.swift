//
//  ChartView.swift
//  Pokedex
//
//  Created by owee on 27/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    
    struct ChartData {
        let key : String
        let value : Int
        let maxValue : Double
        
        var percent : Double {
            return Double(value) / maxValue
        }
    }
    
    @State var isAnimate = false
    
    var data : [ChartData]
    var color : Color
    
    var body: some View {
        
        VStack {
            
            ForEach(self.data, id:\.key) {
                ChartCell(data: $0, color: color, height: 20, Animate: $isAnimate)
            }
            
            
        }.onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isAnimate = true
            }
        }
    }
}

struct ChartCell: View {
    
    let data : ChartView.ChartData
    let color : Color
    let height : CGFloat
    
    @Binding var Animate : Bool
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 2) {
            
            Text("\(data.key)")
                .frame(width: 50,alignment: .leading)
                .font(Font.body.bold())
                .padding(5)
                .foregroundColor(color)
            
            Text("\(data.value)")
                .frame(width: 40)
            
            ZStack {
                
                GeometryReader { geo in
                    
                    Rectangle()
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Rectangle()
                            .fill(color)
                            .frame(width: Animate ? geo.size.width * CGFloat(data.percent) : 0)
                            .cornerRadius(10)
                            .animation(.easeIn(duration: 2))
                        Spacer()
                    }
                }
            }
            .frame(height: self.height)
            .cornerRadius(15)
            .padding(5)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let data : [ChartView.ChartData] = [
            ChartView.ChartData(key: "HP", value: 190, maxValue: 255),
            ChartView.ChartData(key: "ATK", value: 67, maxValue: 255),
            ChartView.ChartData(key: "DEF", value: 97, maxValue: 255),
            ChartView.ChartData(key: "SATK", value: 40, maxValue: 255),
            ChartView.ChartData(key: "SDEF", value: 229, maxValue: 255),
            ChartView.ChartData(key: "SP", value: 90, maxValue: 180),
        ]
        ChartView(data: data, color:.orange)
    }
}
