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
    
    func heightToStringf(_ point: Int = 2) -> String {
        var dPoint: Int = point
        if (point < 0) {
            dPoint = 2
            print("!!!Invalid point Parameter! Please give a value greater than or equal to zero!!!")
        }
        return String(format: "%.\(dPoint)f", self.height)
    }
}
