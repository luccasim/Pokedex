//
//  Test.swift
//  Pokedex
//
//  Created by owee on 22/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

struct Test: View {
    
    @State private var remainingTime : Double = 0.5
    
    private func startAnimation() {
        self.remainingTime = 1
        withAnimation(.linear(duration: 3)) {
            remainingTime = 0
        }
    }
    
    var body: some View {
        VStack {
            logo(iSSet: true)
        }
    }
    
    @ViewBuilder
    func logo(iSSet:Bool) -> some View {
        if iSSet {
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: -(remainingTime*360)-90))
                    .padding(10)
                    .foregroundColor(.orange).opacity(0.4)
                    .onAppear(){
                        self.startAnimation()
                    }
                Text("🎾")
            }
        }
    }
}


struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

struct Pie:Shape {
    
    var startAngle : Angle
    var endAngle: Angle
    
    var animatableData: AnimatablePair<Double,Double> {
        get {AnimatablePair(startAngle.radians, endAngle.radians)}
        set {
            startAngle = Angle(radians: newValue.first)
            endAngle = Angle(radians: newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.height, rect.width) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )

        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: true)
        p.addLine(to: center)
        return p
    }
    
}
