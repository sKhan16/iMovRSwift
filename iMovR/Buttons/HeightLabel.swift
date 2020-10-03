//
//  HeightLable.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightLabel: View {
    
    @Binding var Height: Float
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HeightLable_Previews: PreviewProvider {
    static var previews: some View {
        HeightLabel()
    }
}
