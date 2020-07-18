//
//  DownButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DownButton: View {
    var body: some View {
        Button(action: {
            // What to perform
            moveDown()
        }) {
            // How the button looks like
            Image(systemName: "arrow.down.square")
            .resizable()
            .frame(width: 75, height: 75)
        }
    }
}

func moveDown() {
    print("Moving down!")
}

struct DownButton_Previews: PreviewProvider {
    static var previews: some View {
        DownButton()
    }
}
