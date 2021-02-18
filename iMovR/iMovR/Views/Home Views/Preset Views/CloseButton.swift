//
//  CloseButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/21/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct CloseButton: View {
    @Binding var showSheet: Bool
    var buttonText: String = "Close"
    var body: some View {
        Button(action: {
            self.showSheet = false
        }) {
            Text("Close").bold()
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(showSheet: .constant(true))
    }
}
