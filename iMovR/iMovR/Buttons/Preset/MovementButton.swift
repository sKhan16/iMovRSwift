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
        HStack (alignment: .center) {
        Text("Push & Hold")
            .foregroundColor(Color.white)
            Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
        Text("Touch & Go")
            .foregroundColor(Color.white)
        }
        
    }
}

struct MovementButton_Previews: PreviewProvider {
    static var previews: some View {
        MovementButton(isTouchGo: .constant(true))
    }
}
