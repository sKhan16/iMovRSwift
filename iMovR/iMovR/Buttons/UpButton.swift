//
//  UpButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct UpButton: View {
    var body: some View {
        Button(action: {
            // What to perform
            moveUp()
        }) {
            // How the button looks like
            Image(systemName: "arrow.up.square")
            .resizable()
            .frame(width: 75, height: 75)
        }
    }
}

func moveUp() {
    print("Moving up!")
}

struct UpButton_Previews: PreviewProvider {
    static var previews: some View {
        UpButton()
    }
}
