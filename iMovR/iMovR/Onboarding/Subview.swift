//
//  Subview.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/22/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct Subview: View {
    var imageString: String
    var body: some View {
        Image(imageString)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .clipped()
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        Subview(imageString: "meditating")
    }
}
