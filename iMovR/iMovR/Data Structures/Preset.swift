//
//  Preset.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation

class Preset {
    
    var heightInches: Float
    
    init(height: Float?) {
        guard height != nil else {
            print("error in stored preset height")
            heightInches = -1
            return
        }
        heightInches = height!
    }
    
    func getHeight_inch() -> Float {
        return heightInches
    }
    func getHeight_mm() -> [UInt8] {
        // try rounding up with bitwise logic to sync better to desk
        let tempHeight = Int(heightInches * 25.4)
        return [(UInt8)(tempHeight & 0xFF), (UInt8)((tempHeight>>8) & 0xFF)]
    }
    
}
