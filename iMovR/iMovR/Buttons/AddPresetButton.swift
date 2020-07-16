//
//  AddPresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct AddPresetButton: View {
    var body: some View {
        VStack {
            Image(systemName: "plus.circle")
                .resizable()
                .frame(width: 50.0, height: 50)
            Text("Add Preset")
        }
    }
}

struct AddPresetButton_Previews: PreviewProvider {
    static var previews: some View {
        AddPresetButton()
    }
}
