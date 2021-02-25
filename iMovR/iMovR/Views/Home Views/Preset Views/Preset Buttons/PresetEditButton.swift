//
//  PresetEditButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show = true
            print("Open preset edit popup")
        }) {
            ZStack {
                Circle()
                    .foregroundColor(ColorManager.gray)
                    .frame(width: 45, height: 45)
                Image(systemName: "gearshape")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .accentColor(Color.black)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black, radius: 3, x: 0, y: 3)
                    
            }
        }
    }
}

struct PresetEditButton_Previews: PreviewProvider {
    static var previews: some View {
        PresetEditButton(show: .constant(false))
    }
}
