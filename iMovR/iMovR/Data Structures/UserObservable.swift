//
//  UserObservable.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class UserObservable: ObservableObject {
    @Published var presets: [(name: String, height: Float)] = []
    
    init() {
        //self.addTestPresets()
        
    }
    
    
    //MARK: DELETE THIS AFTER. TESTING ONLY
    func addPreset (name: String, height: Float) {
        presets.append((name, height))
    }
    
    func addTestPresets() {
        for index in (0...10) { 
            self.addPreset(name: "test", height: Float(index))
        }
    }

}
