//
//  Preset.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
/*
 Class that represetns a Preset. It is uniquely identifiable via a UUID
 */

import Foundation

struct Preset: Identifiable {
    
    ///Might want to make these private?
    var name: String
    var height: Float
    
    let id: UUID = UUID()
    
    init(name: String, height: Float?) {
        guard height != nil else {
            print("error in stored preset height")
            self.height = -1
            self.name = ""
            return
        }
        self.height = height!
        self.name = name
    }
    
    func getHeight() -> Float {
        return self.height
    }
    
    func getName() -> String {
        return self.name
    }
    
    
    /*
     Returns string representation of height of the preset to 1 decimal point if no param is given.
     To specified decimal point if param is given
     @param point the decimal point that you want the height at
     */
    func heightToStringf(_ point: Int = 1) -> String {
        var dPoint: Int = point
        if (point < 0) {
            dPoint = 1
            print("!!!Invalid point Parameter! Please give a value greater than or equal to zero!!!")
        }
        return String(format: "%.\(dPoint)f", self.height)
    }
    //    func getHeight_mm() -> [UInt8] {
    //        // try rounding up with bitwise logic to sync better to desk
    //        let tempHeight = Int(heightInches * 25.4)
    //        return [(UInt8)(tempHeight & 0xFF), (UInt8)((tempHeight>>8) & 0xFF)]
    //    }
    
}
