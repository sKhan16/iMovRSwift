//
//  PresetEditButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditButton: View {
    var body: some View {
        Button(action: {
            print("Open preset edit popup")
        }) {
            ZStack {
                Circle()
                    .foregroundColor(Color.gray)
                    .frame(width: 45, height: 45)
                Image(systemName: "gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(.degrees(90))
                    .accentColor(Color.black)
                    .frame(width: 40, height: 40)
                    
            }
        }
        .padding(.bottom)
    }
}

struct PresetEditButton_Previews: PreviewProvider {
    static var previews: some View {
        PresetEditButton()
    }
}
