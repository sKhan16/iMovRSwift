//
//  TreadmillController.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/6/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth

let TreadmillServiceUUID = CBUUID(string:"0x2AD9")
let TreadmillNotifyCharacteristicUUID = CBUUID(string:"0xFEE1")
let TreadmillWriteCharacteristicUUID = CBUUID(string:"0xFEE2")
let TreadmillIO_CharacteristicUUID = CBUUID(string:"0xFEE3")

var ADVERTISED_NAME = "iMovR"

class TreadmillController : ObservableObject {
    @EnvironmentObject var BTManager: DeviceBluetoothManager
    
    private var peripheral: CBPeripheral?
    
    

}
