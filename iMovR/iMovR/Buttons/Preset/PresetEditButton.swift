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
                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Image(systemName: "gear")
                    .accentColor(Color.black)
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
