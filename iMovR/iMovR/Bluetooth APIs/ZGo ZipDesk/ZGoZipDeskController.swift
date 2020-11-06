//
//  ZGoDeskPeripheral.swift
//  iMovR
//
//  ZGoZipDeskController: Control and read properties of ZGo ZipDesk.
//
//  Created by Michael Humphrey on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
import Foundation
import SwiftUI
import CoreBluetooth


///# ZipDesk Bluetooth Service and Characteristic CBUUIDs
let ZGoServiceUUID = CBUUID(string:"0xFEE0")
let ZGoNotifyCharacteristicUUID = CBUUID(string:"0xFEE1")
let ZGoWriteCharacteristicUUID = CBUUID(string:"0xFEE2")
let ZGoIO_CharacteristicUUID = CBUUID(string:"0xFEE3")


class ZGoZipDeskController: ObservableObject {
    
    @Published var deskHeight: Float = 0
    @Published var maxHeight: Float = 1
    @Published var minHeight: Float = 0
    @Published var normalizedHeight: Float = 0.5
    
    private var peripheral: CBPeripheral?
    private var desk: Desk = Desk(name: "uninitialized_desk", deskID: -1)
    
    var writeCharacteristic, readCharacteristic: CBCharacteristic?
    
    private var deskCurrHeight, deskMinHeight, deskMaxHeight: [UInt8]?
    
    
//    init?(connectedDesk: Desk) {
//        guard connectedDesk.peripheral != nil else {
//            print("ZGoZipDeskController.init(..) error: desk peripheral is nil")
//            return nil
//        }
//        self.desk = connectedDesk
//        self.peripheral = connectedDesk.peripheral!
//    }
    
    func setDesk(desk: Desk) -> Bool {
        guard desk.peripheral != nil else {
            print("ZGoZipDeskController:setDesk(..) error- desk peripheral is nil")
            return false
        }
        self.writeCharacteristic = nil
        self.readCharacteristic = nil
        self.peripheral = desk.peripheral!
        self.desk = desk
        return true
    }
    
    func getDesk() -> Desk {
        return self.desk
    }
    
    func getPeripheral() -> CBPeripheral? {
        return self.peripheral
    }
    
    
    
    func updateDisplayedHeights() {
        if var tempMax: Float = self.mmBits2inch(HeightBits: self.deskMaxHeight) {
            // Attempted fix: Rounding height because of ZGo height units conversion bug on desk
            tempMax = (tempMax * 10.0).rounded(.down)/10.0
            DispatchQueue.main.sync { () -> Void in
                self.maxHeight = tempMax
            }
        }
        if let tempMin: Float = self.mmBits2inch(HeightBits: self.deskMinHeight) {
            DispatchQueue.main.sync { () -> Void in
                self.minHeight = tempMin
            }
        }
        if let tempCurr: Float = self.mmBits2inch(HeightBits: self.deskCurrHeight) {
            // fix zipdesk rounding error here
            DispatchQueue.main.sync { () -> Void in
                self.deskHeight = tempCurr
                self.normalizedHeight = (self.deskHeight-self.minHeight)/(self.maxHeight-self.minHeight)
            }
            print("curr height: \(self.deskHeight), normalized: \(self.normalizedHeight)")
        }
    }
    
    let raiseCMD : [UInt8] = [0xA5, 0x03, 0x12, 0x15]
    let lowerCMD : [UInt8] = [0xA5, 0x03, 0x14, 0x17]
    let releaseCMD : [UInt8] = [0xA5, 0x03, 0x10, 0x13]
    //let specificHeightCMD : [UInt8] = [0xA5, 0x05, 0x31, HeightHigh, HeightLow, Checksum]
    
    /// Controller Information Commands:
    let tableStatusInfo : [UInt8] = [0xA5, 0x04, 0x20, 0x01, 0x25]
    let tableHeightInfo : [UInt8] = [0xA5, 0x03, 0x21, 0x24]
    let tableHeightPresetsInfo : [UInt8] = [0xA5, 0x03, 0x22, 0x25]
    // let tableHeightPresetsEditCMD : [UInt8] = [0xA5, 0x03, 0x30, HeightHigh, HeightLow, MemIndex, Checksum]
    
    /// Controller Lock Commands:
    let lockCMD : [UInt8] = [0xA5, 0x04, 0x32, 0x01, 0x37]
    let unlockCMD : [UInt8] = [0xA5, 0x04, 0x32, 0x00, 0x36]
    
    
    private func writeToDesk(data:NSData, type:CBCharacteristicWriteType) {
        guard self.isDeskConnected() else {
            print("writeToDesk error: desk peripheral is not connected")
            return
        }
        guard self.writeCharacteristic != nil else {
            print("writeToDesk error: zipdesk writeCharacteristic not assigned")
            return
        }
        self.peripheral!.writeValue(data as Data, for: self.writeCharacteristic!, type: type)
    }
    
    func raiseDesk() {
        self.writeToDesk(data: Data(_:raiseCMD) as NSData, type: .withoutResponse)
    }
    func lowerDesk() {
        self.writeToDesk(data: Data(_:lowerCMD) as NSData, type: .withoutResponse)
    }
    func releaseDesk() {
        self.writeToDesk(data: Data(_:releaseCMD) as NSData, type: .withoutResponse)
    }
    
    func moveToHeight(PresetHeight:Float) {
        // Convert units and construct desk command
        let heightBits: [UInt8] = self.inch2mmBits(HeightIn: PresetHeight)
        //print("PresetHeight: \(PresetHeight)\nheightBits: \(String(describing: String(bytes: heightBits, encoding: .utf8)))")
        let chksum: UInt8 = UInt8(Int(0x05 + 0x31 + Int(heightBits[1]) + Int(heightBits[0])) & 0xFF)
        //print(chksum)
        let specificHeightCMD: [UInt8] = [0xA5, 0x05, 0x31, heightBits[1], heightBits[0], chksum]
        //print(specificHeightCMD)
        self.writeToDesk(data: Data(_:specificHeightCMD) as NSData, type: .withoutResponse)
    }
    
    // Called when desk initializes
    func requestHeightsFromDesk() {
        self.writeToDesk(data: Data(_:tableHeightInfo) as NSData, type: .withResponse)
    }
    
    // Called after desk notifies that the read characteristic has been updated
    func identifyMessage() {
        guard self.readCharacteristic != nil else {
            print("zipdesk.identifyMessage(): zipdesk readCharacteristic not assigned")
            return
        }
        guard let readData: Data = self.readCharacteristic?.value else {
            print("zipdesk.identifyMessage(): invalid read characteristic value (nil)")
            return
        }
        guard readData.count > 3 else {
            print("zipdesk.identifyMessage(): read characteristic data length too small")
            return
        }
        let readByteData: [UInt8] = [UInt8](readData)
        
        guard let msgChecksum: UInt8 = readByteData.last else {
            return
        }
        // MARK: Checksum verification
        
        //print("message checksum = \(String(describing: msgChecksum))")
        var calcChecksum: UInt = 0
        for i in 1 ..< (readByteData.count - 1) {
            //print(calcChecksum)
            calcChecksum += UInt(readByteData[i])
        }
        calcChecksum = calcChecksum & 0xFF
        //print("calculated checksum = \(String(describing: calcChecksum))")
        
        guard calcChecksum == msgChecksum else {
            print("checksum error - received invalid message from desk")
            return
        }
        
        //MARK: Identifying the received message
    
        if readByteData[0...2] == [0x5A,0x09,0x21] {
            guard readByteData.count == 10 else {
                print("readData count invalid")
                return
            }
            print("successfully detected message: Table Height Information")
            self.deskCurrHeight = [readByteData[4],readByteData[3]]
            self.deskMinHeight = [readByteData[6],readByteData[5]]
            self.deskMaxHeight = [readByteData[8],readByteData[7]]
            self.updateDisplayedHeights()
            
        } else if readByteData[0...1] == [0x5A,0x06] {
            guard readByteData.count == 7 else {
                print("readData count invalid")
                return
            }
            print("successfully detected message: Movement/Status Change Update")
            self.deskCurrHeight = [readByteData[4],readByteData[3]]
            self.updateDisplayedHeights()
            
        } else {
            print("readData message unidentified in updateHeightInfo()")
            print(readData.map { String(format: "%02x", $0) }.joined())
            return
        }
    }// end updateHeightInfo()
    
    
    // Convert height in millimeters to inches
    private func mmBits2inch(HeightBits: [UInt8]?)->Float? {
        guard (HeightBits != nil) else {
            print("zipdesk.mmBits2Inch error: nil HeightBits")
            return nil
        }
        guard (HeightBits?.count == 2) else {
            print("zipdesk.mmBits2Inch error: HeightBits is not 2 bytes long")
            return nil
        }
        return Float(Int(HeightBits![1])<<8 + Int(HeightBits![0])) / 25.4
    }
    
    // Convert height in inches to millimeters in [UInt8] 2 byte array form
    private func inch2mmBits(HeightIn: Float)->[UInt8] {
        // try rounding up with bitwise logic to sync better to desk
        let Height = Int(HeightIn * 25.4)
        return [(UInt8)(Height & 0xFF), (UInt8)((Height>>8) & 0xFF)]
    }
    
    private func isDeskConnected() -> Bool {
        guard self.peripheral?.state == .connected else {
            print("error: desk peripheral not connected")
            return false
        }
        return true
    }
    
} // end ZGoDeskPeripheral
