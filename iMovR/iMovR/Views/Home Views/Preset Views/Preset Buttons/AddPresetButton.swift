//
//  AddPresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetButton: View {

    @Environment(\.colorScheme) var colorScheme
    
    var Unpressed: Image = Image("ButtonRoundDark")
    var Pressed: Image = Image("ButtonRoundDarkBG")
    var geoWidth: CGFloat
    
    let index: Int
    @Binding var showAddPreset: Bool
    
    
    var body: some View {
        ZStack {
            (self.showAddPreset ? Pressed : Unpressed)
                .resizable()
                .frame (
                    width: ((geoWidth - 60)/4),
                    height: ((geoWidth - 60)/4)
                )
            Image(systemName: "plus")
                .resizable()
                .frame (
                    width: ((geoWidth - 60)/8),
                    height: ((geoWidth - 60)/8)
                )
                .foregroundColor(Color.blue)
        }
        .gesture (
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    self.showAddPreset = true
                })
        )
        .sheet(isPresented: self.$showAddPreset) {
            AddPresetView(showAddPreset: self.$showAddPreset, index: self.index)
        }
    }
}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton(geoWidth: CGFloat(300), index: 0, showAddPreset: .constant(false))
    }
}
