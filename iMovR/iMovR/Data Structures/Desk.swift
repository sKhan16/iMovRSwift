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

struct Desk: Identifiable { // inherit from Device, make Desk a class, in DeviceBluetoothManager compare&discover Devices instead of Desks
    
    var name: String
    var id: Int
    var peripheral: CBPeripheral?
    var rssi: NSNumber?
    var presetHeights: [Float] = [30.0, 37.0, 38.0, -1.0, -1.0, -1.0]
    var presetNames: [String] = ["Sitting", "Standing", "Walking", "Preset 4", "Preset 5", "Preset 6"]
    
    // DeviceData Manager/CoreData Saved Desk Constructor
    init(name: String, deskID: Int, presetHeights: [Float], presetNames: [String]) {
        self.name = name
        self.id = deskID
        // override default preset values
        self.presetHeights = presetHeights
        self.presetNames = presetNames
        
    }
    init(zipdeskData: ZipDeskData) {
        self.name = zipdeskData.name
        self.id = Int(zipdeskData.deskID)
        self.presetHeights = zipdeskData.presetHeights
        self.presetNames = zipdeskData.presetNames
    }
    
    // DeviceBTManager Discovered Desk Constructor
    init(deskID: Int, deskPeripheral: CBPeripheral, rssi: NSNumber?) {
        self.name = "Discovered ZipDesk"
        self.id = deskID
        self.peripheral = deskPeripheral
        self.rssi = rssi
    }
    
}
