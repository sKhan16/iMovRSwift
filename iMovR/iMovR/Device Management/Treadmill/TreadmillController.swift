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
//below used to be named TreadmillAdServiceUUID
public let FitnessMachineServiceUUID = CBUUID(string: "00001826-0000-1000-8000-00805F9B34FB")
//let TreadmillServiceUUID = CBUUID(string:"0x2AD9") control point used to turn on and off.

//The following chars are accessed through another service uuid
let TreadmillNotifyCharacteristicUUID = CBUUID(string:"0xFEE1")
let TreadmillWriteCharacteristicUUID = CBUUID(string:"0xFEE2")
let TreadmillIO_CharacteristicUUID = CBUUID(string:"0xFEE3")

//COPIED FROM PYTHON SCRIPT--
//FITNESS_MACHINE_SERVICE = VendorUUID('00001826-0000-1000-8000-00805F9B34FB') #_0000_1000_8000_00805f9b34fb
//FMCP_CHARACTERISTIC = VendorUUID('00002ad9-0000-1000-8000-00805F9B34FB')
//## cant use uuid's that are 32 bit with adafruit
//IO_CHARACTERISTIC = VendorUUID('8ec92001-0000-1000-8000-00805F9B34FB')
//NOTIFY_CHARACTERISTIC = VendorUUID('8ec92002-0000-1000-8000-00805F9B34FB')
//    #changed VendorUUID to StandardUUID, revert if weird bugs happen


//Treadmill Commands
let SET_UNIT_METRIC: [UInt8] = [0xE,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
        //[0xE, 11*(0x0)]
        //[0xE,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
        //CBUUID(string: "0xE00000000000") //0xE0_00_00000000
let SET_UNIT_ENGLISH: [UInt8] = [0xE,0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE00100000000")
    //0xE0_01_00000000
let SET_SPEED: [UInt8] = [0xE,0x1,0x4,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE14000000000")
    //0xE1_40_00000000
let SET_WEIGHT_STRIDE: [UInt8] = [0xE,0x8,0x0,0x0,0xF,0x0,0x2,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE800F0200000")
    //0xE8_00F0_20_0000
let REQ_ALL_DATA: [UInt8] = [0xE,0x2,0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE20100000000")
    //0xE2_01_00000000
let REQ_ENTERPRISE_STATUS: [UInt8] = [0xE,0x2,0xE,0x3,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE2E300000000")
    //0xE2_E3_00000000
let ENTERPRISE_MODE_OFF: [UInt8] = [0xE,0x3,0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x0]
    //CBUUID(string: "0xE30001000000")
    //0xE3_00_01_000000
let ENTERPRISE_MODE_ON: [UInt8] = [0xE,0x3,0x0,0x1,0x0,0x1,0x0,0x1,0x0,0x0,0x0,0x5]
    //CBUUID(string: "0xE30101010005")
    // 0xE3_01_01_01_0005

var ADVERTISED_NAME = "iMovR"

class TreadmillController : ObservableObject {
    @EnvironmentObject var BTManager: DeviceBluetoothManager
    
    private var peripheral: CBPeripheral?
    
    var writeCharacteristic, readCharacteristic: CBCharacteristic?
    
    var msgArray: [[UInt8]] = [REQ_ENTERPRISE_STATUS, REQ_ALL_DATA,
                              SET_UNIT_ENGLISH, SET_SPEED, SET_WEIGHT_STRIDE,
                              REQ_ALL_DATA, ENTERPRISE_MODE_OFF, ENTERPRISE_MODE_ON]

    func setPeripheral(_ peripheral: CBPeripheral?)
    {
        if peripheral != nil
        {
            self.peripheral = peripheral
        }
    }
    
    private func readResp(resp: Int) {
        if (resp == 0x80E101) {
            print("Set desired speed OK")
        } else if (resp == 0x80E104) {
            print("Set desired speed FAILED")
        }
        if (resp == 0x80E201) {
            print("App control command OK")
        } else if (resp == 0x80E204) {
            print("App control command FAILED")
        }
        if (resp == 0x80E301) {
            print("Set enterprise mode OK")
        } else if (resp == 0x80E304) {
            print("Set enterprise mode FAILED")
        }
        if (resp == 0x80E801) {
            print("Set Weight and stride OK")
        } else if (resp == 0x80E804) {
            print("Set Weight and stride FAILED")
        }
    }
    
    private func writeToTreadmill(data:NSData, type:CBCharacteristicWriteType) {
        guard self.isTreadmillConnected() else {
            print("writeToTreadmill error: treadmill peripheral is not connected")
            return
        }
        guard self.writeCharacteristic != nil else {
            print("writeToTreadmill error: treadmill writeCharacteristic not assigned")
            return
        }
        self.peripheral!.writeValue(data as Data, for: self.writeCharacteristic!, type: type)
    }

    ///Might not be connected. And have to change everything to use this class.
    private func isTreadmillConnected() -> Bool {
        guard self.peripheral?.state == .connected else {
            print("zipdesk.isDeskConnected -- ERROR: peripheral not connected")
            return false
        }
        return true
    }
    
    func testCmds() {
        var timer: Timer?
        for cmd in msgArray {
            self.writeToTreadmill(data: Data(_:cmd) as NSData, type: .withoutResponse)
            //Set timer for 5 second intervals.
        }
    }
    
    func testPrint() {
        if self.isTreadmillConnected() {
            print("Treadmill is connected")
            print("Start Connection to Treadmill")
        } else {
            print("Treadmill is not connected")
        }
        
    }
    
}
