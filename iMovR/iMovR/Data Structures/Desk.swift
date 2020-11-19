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
    var connectionStatus: Bool?
    
    // Save desk info from CoreData before discovering...
    init(name: String, deskID: Int) {
        self.name = name
        self.id = deskID
    }
    
    // Save discovered desk before user chooses a name
    init(deskID: Int, deskPeripheral: CBPeripheral, rssi: NSNumber?) {
        self.id = deskID
        self.peripheral = deskPeripheral
        self.rssi = rssi
        
        if rssi != nil { self.name = "Discovered ZipDesk" }
        else { self.name = "desk manually connected with no rssi" }
    }
    
}
