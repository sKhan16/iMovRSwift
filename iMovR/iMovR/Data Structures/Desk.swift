//
//  Desk.swift
//  iMovR
//
//  Created by Shakeel Khan on 8/4/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
/*
 Class that represents a desk. It is uniquely identifiable via a UUID
 */
import Foundation
import CoreBluetooth

// future plan: make Desk a class that inherits from Device; in DeviceBluetoothManager compare and discover 'Devices' instead of only 'Desks'

struct Desk: Identifiable {
    
    var name: String
    var id: Int
    
    var peripheral: CBPeripheral?
    var rssi: NSNumber?
    var inRange: Bool = false
    
    var isLastConnected: Bool
    
    // Default preset values, unless modified on desk initialization
    var presetHeights: [Float] = [30.0, 37.0, 38.0, -1.0, -1.0, -1.0]
    var presetNames: [String] = ["Sit", "Stand", "Walk", "Preset 4", "Preset 5", "Preset 6"]
    
    
    // DeviceDataManager & CoreData Saved Desk Constructor
    init(name: String, deskID: Int, presetHeights: [Float], presetNames: [String], isLastConnected: Bool) {
        self.name = name
        self.id = deskID
        // override default preset values
        self.presetHeights = presetHeights
        self.presetNames = presetNames
        self.isLastConnected = isLastConnected
        
    }
//    init(zipdeskData: ZipDeskData) {
//        self.name = zipdeskData.name
//        self.id = Int(zipdeskData.deskID)
//        self.presetHeights = zipdeskData.presetHeights
//        self.presetNames = zipdeskData.presetNames
//    }
    
    // DeviceBTManager Discovered Desk Constructor
    init(deskID: Int, deskPeripheral: CBPeripheral, rssi: NSNumber?) {
        self.name = "Discovered Device"
        self.id = deskID
        self.peripheral = deskPeripheral
        self.inRange = ((rssi as? Double) ?? -1000.0) > -80.0 // -80.0dB -> ~3.5 meters away; test & adjust
        self.rssi = rssi
        self.isLastConnected = false
    }
    
}
