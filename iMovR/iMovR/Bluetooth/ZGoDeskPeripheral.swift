//
//  ZGoDeskPeripheral.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/18/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
import CoreBluetooth

///# ZGo Desk Service and Characteristic CBUUIDs
let ZGoServiceUUID = CBUUID(string:"0xFEE0")
let ZGoNotifyCharacteristicUUID = CBUUID(string:"0xFEE1")
let ZGoWriteCharacteristicUUID = CBUUID(string:"0xFEE2")
let ZGoIO_CharacteristicUUID = CBUUID(string:"0xFEE3")

///# ZGoDeskPeripheralWrapper: Contains controls for ZGo desk
class ZGoDeskPeripheral {
    
    
    
    let deskPeripheral: CBPeripheral
    let writeCharacteristic, readCharacteristic: CBCharacteristic
    private var deskHeight, deskMinHeight, deskMaxHeight: [UInt8]?
    // we should have a setting for inches or centimeter measurements!
    
    init(peripheral:CBPeripheral, write:CBCharacteristic, read:CBCharacteristic) {
        self.deskPeripheral = peripheral
        self.writeCharacteristic = write
        self.readCharacteristic = read
        self.requestHeightFromDesk()
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
    
    
    func writeToDesk(data:NSData, type:CBCharacteristicWriteType) {
        self.deskPeripheral.writeValue(data as Data, for: self.writeCharacteristic, type: type)
    } /*
     func readFromDesk() {
     return self.deskPeripheral.readValue(for: self.readCharacteristic)
     } */
    
    func raiseDesk() {
        self.writeToDesk(data: Data(_:raiseCMD) as NSData, type: .withoutResponse)
    }
    func lowerDesk() {
        self.writeToDesk(data: Data(_:lowerCMD) as NSData, type: .withoutResponse)
    }
    func releaseDesk() {
        self.writeToDesk(data: Data(_:releaseCMD) as NSData, type: .withoutResponse)
    }
    
    
    func moveToHeight(PresetHeight:Double) {
        
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
    func requestHeightFromDesk() {
        self.writeToDesk(data: Data(_:tableHeightInfo) as NSData, type: .withResponse)
    }
    
    // Called after desk notifies that the height info has been updated
    func updateHeightInfo() {
        
        guard let readData: Data = self.readCharacteristic.value else {
            print("invalid read characteristic value (nil)")
            return
        }
        guard readData.count > 4 else {
            print("read characteristic count too small")
            return
        }
        
        let readByteData: [UInt8] = [UInt8](readData)
        //print(readByteData)
        /*
         let readIntArray: [Int] = []
         for (index,currByte) in readByteData[1..<(readByteData.endIndex - 1)] {
         
         }
         // Verify checksum of message:
         let chksum: [Int] = [Int](readByteData[1..<(readByteData.endIndex-1)])
         guard chksum.reduce(0,+) & 0xFF == readByteData.last! else {
         print("readData checksum invalid")
         return
         }
         func convertType(typeIn: [Int]) -> [UInt8] {
         return [UInt8](arrayLiteral: UInt8(typeIn[0]),UInt8(typeIn[1]))
         }
         */
        if readByteData[0...2] == [0x5A,0x09,0x21] {
            guard readByteData.count == 10 else {
                print("readData count invalid")
                return
            }
            print("successfully detected message: Table Height Information")
            self.deskHeight = [readByteData[4],readByteData[3]]
            self.deskMinHeight = [readByteData[6],readByteData[5]]
            self.deskMaxHeight = [readByteData[8],readByteData[7]]
            /*self.deskHeight = convertType(typeIn: Array(readByteData[3...4]))
             self.deskMinHeight = convertType(typeIn: Array(readByteData[5...6]))
             self.deskMaxHeight = convertType(typeIn: Array(readByteData[7...8]))
             */
        } else if readByteData[0...1] == [0x5A,0x06] {
            guard readByteData.count == 7 else {
                print("readData count invalid")
                return
            }
            //print("successfully detected message: Movement/Status Change Update")
            //self.deskHeight = convertType(typeIn: Array(readByteData[3...4]))
            self.deskHeight = [readByteData[4],readByteData[3]]
            
        } else {
            print("readData message invalid in updateHeightInfo()")
            return
        }
        //print("Current height from desk: \(String(String(bytes: self.deskHeight!, encoding: .utf8) ?? String("nil")))")
        /*
         switch (readData[0...2]) {
         case: (0x5A,0x09,0x21)
         //    print("successfully detected message: Table Height Information")
         default:
         print("readData message invalid in updateHeightInfo()")
         return
         }
         */
        
        // Must check that value represents a height update command:
        // use switch/case statement for sender command; this function can be accessed by requesting desk height or moving the desk
        
        //[UInt8] characteristic.value == [0x5A, 0x06, CMD, Height_H, Height_L, ErrorCode, Checksum]:[UInt8]
        
        // also verify checksum and message length and such
        
        // Then extract the curr, min and max heights
        // Then update UISlider values to match
        //self.readFromDesk()
        //self.readCharacteristic.value
        /*
         self.deskHeight =
         self.deskMaxHeight =
         self.deskMinHeight =
         */
    }
    
    func getHeightInches() -> Float? {
        return self.mmBits2inch(HeightBits: self.deskHeight)
    }
    func getMinHeightInches() -> Float? {
        return self.mmBits2inch(HeightBits: self.deskMinHeight)
    }
    func getMaxHeightInches() -> Float? {
        return self.mmBits2inch(HeightBits: self.deskMaxHeight)
    }
    
    // Convert height in millimeters to inches
    private func mmBits2inch(HeightBits: [UInt8]?)->Float? {
        guard (HeightBits != nil) && (HeightBits?.count == 2) else {
            print("mmToInch error")
            return nil
        }
        return Float(Int(HeightBits![1])<<8 + Int(HeightBits![0])) / 25.4
    }
    
    // Convert height in inches to millimeters in [UInt8] 2 byte array form
    private func inch2mmBits(HeightIn: Double)->[UInt8] {
        // try rounding up with bitwise logic to sync better to desk
        let Height = Int(HeightIn * 25.4)
        return [(UInt8)(Height & 0xFF), (UInt8)((Height>>8) & 0xFF)]
    }
    
} // end DeskPeripheralWrapper
