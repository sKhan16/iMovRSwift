//
//  PresetNew.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
/*
 Data Struct for Preset.
 */

import Foundation

struct PresetNew: Identifiable {
    
    var name: String
    var height: Float
    let id: UUID
    
    init(name: String, height: Float) {
        self.height = height
        self.name = name
        self.id = UUID()
    }
    
    func heightToString() -> String {
        return String(format: "%.\(2)f", self.height)
    }
}
