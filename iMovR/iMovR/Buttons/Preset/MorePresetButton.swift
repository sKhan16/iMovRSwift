//
//  MorePresetButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/13/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct MorePresetButton: View {
    
    @Binding var isPaged: Bool
    
    var body: some View {
        Button(action: {
            self.isPaged.toggle()
        }) {
            VStack {
                ZStack {
                    Circle()
                        //.resizable()
                        //.stroke(Color.black, lineWidth: 3)
                        //.background(Circle().foregroundColor(ColorManager.preset))
                        .frame(width: 80.0, height: 80)
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 40, height: 10)
                        .foregroundColor(Color.white)
                }
            }
            .foregroundColor(ColorManager.morePreset)
    }
}

struct MorePresetButton_Previews: PreviewProvider {
    static var previews: some View {
        MorePresetButton(isPaged: .constant(true))
    }
}
}
