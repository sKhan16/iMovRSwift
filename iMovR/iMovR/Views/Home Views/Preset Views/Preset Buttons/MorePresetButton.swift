//
//  MorePresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/13/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct MorePresetButton: View {
    
    @Binding var isPaged: Bool
    
    var Unpressed: Image = Image("ButtonRoundDark")
    var Pressed: Image = Image("ButtonRoundDarkBG")
    var geoWidth: CGFloat
    
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            ZStack {
                (isPressed ? Pressed : Unpressed)
                    .resizable()
                    .frame (
                        width: (geoWidth - 60)/4,
                        height: (geoWidth - 60)/4
                    )
                Image(systemName: isPaged ? "arrowshape.turn.up.left.fill" : "arrowshape.turn.up.right.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame (
                        width: (geoWidth - 60)/8,
                        height: (geoWidth - 60)/8
                    )
                    .foregroundColor((isPressed ? ColorManager.buttonPressed : ColorManager.buttonStatic))
            }
        }
        .gesture (
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    self.isPressed = true
                    self.isPaged.toggle()
                })
                .onEnded({ _ in
                    self.isPressed = false
                })
        )
    }
}

struct MorePresetButton_Previews: PreviewProvider {
    static var previews: some View {
        MorePresetButton(isPaged: .constant(true), geoWidth: CGFloat(300))
    }
}
