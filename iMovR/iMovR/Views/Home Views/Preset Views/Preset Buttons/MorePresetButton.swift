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
    
    var Pressed = Image("NextPresets_OLD")
    var Unpressed = Image("NextPresetsPressed_OLD")

    @State private var NextPresetsBG = false
    @State private var fadeOut: Bool = false
    
    var body: some View {
        Button(action: {
            self.isPaged.toggle()
            self.NextPresetsBG.toggle()
        }) {
            VStack {
                ZStack {
                    (NextPresetsBG ? Pressed : Unpressed)
                        .resizable()
                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onChanged({ _ in
//                                    NextPresetsBG = true
//                                })
//                                .onEnded({ _ in
//                                    NextPresetsBG = false
//                                }))
//                    
                    
                    
                    
//                    Circle()
//                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
//                    Image(systemName: isPaged ? "arrowshape.turn.up.left.fill" : "arrowshape.turn.up.right.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 45)//,height: 10)
//                        .foregroundColor(Color.white)
                }
            }
            .foregroundColor(ColorManager.morePreset)
    }
}

struct MorePresetButton_Previews: PreviewProvider {
    static var previews: some View {
        MorePresetButton(isPaged: .constant(true))
    }
}
}
