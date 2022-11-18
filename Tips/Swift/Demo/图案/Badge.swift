//
//  Badge.swift
//  Tips
//
//  Created by lss on 2022/11/17.
//

import SwiftUI

struct Badge: View {
    
    @Binding var badgePagePresented: Bool
    
    static let rotationCount = 8

    var badgeSymbols: some View {
        ForEach(0..<Badge.rotationCount) { i in
            RotatedBadgeSymbol( angle: .degrees(Double(i) / Double(Badge.rotationCount)) * 360.0)
        }
    }
    
    var body: some View {
        Button {
            badgePagePresented = false
        } label: {
            Text("Dismiss")
        }

        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                self.badgeSymbols
                .scaleEffect(1.0 / 4.0, anchor: .top)
                .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
        
        
    }
    
    func dismiss() {
        
    }
}
//
//struct Badge_Previews: PreviewProvider {
//    static var previews: some View {
//        Badge()
//    }
//}
