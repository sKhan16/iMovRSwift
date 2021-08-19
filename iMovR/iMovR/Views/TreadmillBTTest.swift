//
//  TreadmillBTTest.swift
//  iMovR
//
//  Created by Shakeel Khan on 6/29/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct TreadmillBTTest: View {
    
    @ObservedObject var treadmill: TreadmillController
    
    var body: some View {
        Button(action: {
            treadmill.testPrint()
        }) {
            Text("Connect to Treadmill")
        }
    }
}

struct TreadmillBTTest_Previews: PreviewProvider {
    static var previews: some View {
        TreadmillBTTest(treadmill: TreadmillController())
    }
}
