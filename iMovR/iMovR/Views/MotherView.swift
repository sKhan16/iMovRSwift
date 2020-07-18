//
//  MotherView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    var body: some View {
        HStack {
            if viewState == 0 {
                onboardingView()
            }
            Text("Mother View")
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
