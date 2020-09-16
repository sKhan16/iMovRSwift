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

struct Desk: Identifiable {
    
    var name: String
    var id: Int
    var peripheral: CBPeripheral?
    
    init(name: String, deskID: Int) {
        self.name = name
        self.id = deskID
    }
    
    init(deskID: Int, peripheral: CBPeripheral) {
        self.id = deskID
        self.peripheral = peripheral
        
        self.name = "Discovered Desk"
    }
}
