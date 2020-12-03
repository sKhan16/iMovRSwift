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
                        .frame(minWidth: 70, idealWidth: 80, maxWidth: 80, minHeight: 70, idealHeight: 80, maxHeight: 80)
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
