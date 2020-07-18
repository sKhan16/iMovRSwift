//
//  MotherView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    // Variables here
    
    
    var body: some View {
        HStack {
            Text("Mother View")
            //self.pickView()
            
        }
    }
}

//enum viewState: Int {
//    case onboarding = 0
//    case home = 1
//    case edit_presets = 2
//}
 
//func pickView() -> AnyView {
//    switch viewState(superViewState) {
//        case onboarding:
//            return onboardingView()
//        case home:
//            return HomeView()
//        case edit_presets:
//            return Text("error")
//    }
//}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
