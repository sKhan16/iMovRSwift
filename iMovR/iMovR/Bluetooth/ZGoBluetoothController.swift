//
//  ZGoBluetoothController.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth


class ZGoBluetoothController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    @EnvironmentObject var user: UserObservable

    
    // Published variables (update UI when changed)
    @Published var currentHeight: Float = 0
    @Published var maxHeight: Float = 1
    @Published var minHeight: Float = 0
    
    @Published var connectionStatus: String = "Connect to a Desk"
    @Published var connectionColor: Color = Color.primary
    @Published var isConnected = false
    
    @Published var deskWrap: ZGoDeskPeripheral?
    
    @State var deskUpdatedHeight = false
    
    
    override init() {
        super.init()
        // Create asynchronous queue for UI changes within Core Bluetooth methods
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    //MARK: Bluetooth Objects
    var centralManager: CBCentralManager?
    var deskPeripheral: CBPeripheral?
    
    var writeCharacteristic, readCharacteristic: CBCharacteristic?
    
    var bluetoothReadyFlag = false
    
    
    func startConnection() {
        guard user.currentDesk.id > 0 else {
            print("invalid deskID stored, or user hasn't input deskID yet")
            connectionStatus = "Invalid Desk ID\nPlease Change"
            connectionColor = Color.red
            return
        }
        guard self.bluetoothReadyFlag else {
            print("bluetooth not ready yet")
            connectionStatus = "Turn On Bluetooth To Continue"
            connectionColor = Color.red
            return
        }
        
        print("Scanning for peripherals with service: \(ZGoServiceUUID)")
        connectionStatus = "Scanning For Desks"
        connectionColor = Color.primary
        // BT is on, now scan for peripherals that match the CBUUID
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID]);
    }
    
    func updateDeskHeights() {
        if let temp = deskWrap?.getHeightInches() {
            DispatchQueue.main.async { () -> Void in
                self.currentHeight = temp
            }
        }
        if let temp = deskWrap?.getMaxHeightInches() {
            DispatchQueue.main.async { () -> Void in
                self.maxHeight = temp
            }
        }
        if let temp = deskWrap?.getMinHeightInches() {
            DispatchQueue.main.async { () -> Void in
                self.minHeight = temp
            }
        }
    }
    

    //MARK: CoreBluetooth Delegated Connection Functions
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Only want to scan for peripherals when the Bluetooth manager state is .poweredOn
        print("Checking Bluetooth status")
        switch central.state {
        // Bad cases: Bluetooth is not yet ready
        case .unknown:
            print("Bluetooth status is UNKNOWN")
            bluetoothReadyFlag = false
        case .resetting:
            print("Bluetooth status is RESETTING")
            bluetoothReadyFlag = false
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
            bluetoothReadyFlag = false
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
            bluetoothReadyFlag = false
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in
                self.connectionStatus = "Turn On Bluetooth To Continue"
                self.connectionColor = Color.red
            }
        // Ideal case: Bluetooth is powered on, scan for desks
        case .poweredOn:
            DispatchQueue.main.async { () -> Void in
                self.connectionStatus = "Connect To A Desk"
                self.connectionColor = Color.primary
            }
            print("Bluetooth status is POWERED ON")
            // scan when user clicks the Connect To Desk button
            bluetoothReadyFlag = true
        // Exception:
        @unknown default:
            print("Bluetooth status EXCEPTION")
            bluetoothReadyFlag = false
        }
    }
    
    //MARK: centralManager methods for interacting with the bluetooth peripheral
    
    // didDiscover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // MARK: Verify manufacturer deskID matches user input deskID
        var manufacturerData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3k, where 'k' is a digit of the 8 digit manufacturer unique ID.
        // 0x30 = 48 = 3 * 2^4
        for index in manufacturerData.indices {
            manufacturerData[index] -= 48;
        }
        var manufacturerDeskID : Int = 0
        for (index, digit) in manufacturerData.enumerated() {
            manufacturerDeskID += Int(digit) * Int(pow(10,Double(7-index)))
        }
        //print("corrected manufacturerID: \(manufacturerDeskID)")
        
        guard manufacturerDeskID == user.currentDesk.id else {
            print("Desk \(String(manufacturerDeskID)) did not match user-stored value \(String(user.currentDesk.id))")
            DispatchQueue.main.async { () -> Void in
                self.connectionStatus = "ID Didn't Match Discovered Desk(s)"
                self.connectionColor = Color.red
            }
            return
        }
        
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "ID Matches Discovered Desk"
            self.connectionColor = Color.primary
        }
        print("Connecting to desk with ID:\n \(manufacturerData)")
        
        deskPeripheral = peripheral
        // Must set delegate of peripheralZGoDesk to ViewController(self)
        deskPeripheral?.delegate = self
        // Stop scanning for peripherals to save battery life
        centralManager?.stopScan()
        // Connect to the discovered peripheral
        //print("Connecting to peripheral")
        centralManager?.connect(deskPeripheral!)
    } // end didDiscover peripheral
    
    
    // didConnect: Invoked when a peripheral is connected successfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Connected To Desk"
            self.connectionColor = Color.green
        }
        
        self.isConnected = true
        user.addDesk()
        
        deskPeripheral?.discoverServices([ZGoServiceUUID])
    }
    
    
    // didDisconnectPeripheral: When the peripheral disconnects, start scanning on BT again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected; now scanning")
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Desk Disconnected"
            self.connectionColor = Color.primary
        }
        self.isConnected = false
        // Start scanning for (ZGo) desks again
        //MARK:~~~Maybe this should look for paired devices before scanning for new ones~~~
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    // didDiscoverServices: makes sure the desk has the correct service before continuing
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == ZGoServiceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // didDiscoverCharacteristicsFor:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            //print(characteristic)
            if characteristic.uuid == ZGoWriteCharacteristicUUID {
                writeCharacteristic = characteristic
            }
            
            if characteristic.uuid == ZGoNotifyCharacteristicUUID {
                readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: readCharacteristic!)
            }
            
        } // END for - characteristic search
        
        // Initialize deskWrap to interact with desk later
        DispatchQueue.main.async { () -> Void in
            self.deskWrap = ZGoDeskPeripheral(peripheral: self.deskPeripheral!, write: self.writeCharacteristic!, read: self.readCharacteristic!)
        }
    } // END func peripheral(... didDiscoverCharacteristicsFor service
    
    
    // Called when readCharacteristic value is updated by the peripheral
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error:Error?) {
        guard error == nil else {
            print("didUpdateValueFor error: characteristic value update threw error - from notify or readValue(...)"); return
        }
        guard characteristic.uuid == ZGoNotifyCharacteristicUUID else {
            print("didUpdateValueFor error: updated characteristic is not ZGoNotifyCharacteristic")
            return
        }
        //print("didUpdateValueFor readCharacteristic")
        deskWrap?.updateHeightInfo()
        self.updateDeskHeights()
        
    }

}// end ZGoBluetoothController
    

