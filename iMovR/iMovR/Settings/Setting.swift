//
//  Setting.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//  The model for an individual setting

import SwiftUI

struct Setting: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    //add image var
}


struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
