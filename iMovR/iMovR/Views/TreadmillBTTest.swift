//
//  TreadmillBTTest.swift
//  iMovR
//
//  Created by Shakeel Khan on 6/29/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct TreadmillBTTest: View {
    var body: some View {
        Button(action: {
            print("Start Connection to Treadmill")
        }) {
            Text("Connect to Treadmill")
        }
    }
}

struct TreadmillBTTest_Previews: PreviewProvider {
    static var previews: some View {
        TreadmillBTTest()
    }
}
