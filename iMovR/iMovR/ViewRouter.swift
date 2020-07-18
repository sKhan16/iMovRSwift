//
//  ViewRouter.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject {
    
    init() {
        
        // Shows onboarding screen ONLY on first launch of app.
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "OnboardingView"
        } else {
            currentPage = "ContentView"
        }
    }
    
    @Published var currentPage: String
    
}

