//
//  EditPresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditPresetButton: View {
    var body: some View {
        VStack {
            Image(systemName: "ellipsis")
                .resizable()
                .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 4) )
                .frame(width: 50, height: 10)
        }
    }
}

struct EditPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        EditPresetButton()
    }
}
