//
//  MovementButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct MovementButton: View {
    @Binding var isTouchGo: Bool
    var body: some View {
        Button(action: {
            if self.isTouchGo {
                self.isTouchGo = false
            } else {
                self.isTouchGo = true
            }
        }) {
            if isTouchGo {
                Text("Touch and Go")
                    .foregroundColor(Color.white)
            } else {
                Text("Push and Hold")
                    .foregroundColor(Color.white)
            }
        }
        
    }
}

struct MovementButton_Previews: PreviewProvider {
    static var previews: some View {
        MovementButton(isTouchGo: .constant(true))
    }
}
