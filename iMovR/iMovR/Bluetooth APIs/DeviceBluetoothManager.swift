//
//  DeviceBluetoothManager.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth


class DeviceBluetoothManager: NSObject, ObservableObject,
                              CBCentralManagerDelegate, CBPeripheralDelegate {
///# Discovered Devices
    @Published var discoveredDevices: [Desk] = []
    @Published var savedDevices: [Desk] = []
    
///# Current Desk
    @Published var zipdesk: ZGoZipDeskController?
    @Published var isDeskConnected: Bool = false

    
///# Current Monitor Arm
    // @Published var isMonitorArmConnected: Bool = false
///# Current Treadmill
    // @Published var isTreadmillConnected: Bool = false
    
///# Local Bluetooth Objects
    private var centralManager: CBCentralManager?
    private var desiredPeripheral: CBPeripheral?

    private var bluetoothReadyFlag = false
    
///# Initializer
    override init() {
        super.init()
        // Create asynchronous queue for UI changes within Core Bluetooth methods
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    // preview test mode initializer
    init?(previewMode: Bool) {
        guard previewMode else { return nil }
        super.init()
        self.setTestMode()
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    
    
///# Connection Status
    enum ConnectionStatus {
        case disabled, ready, scanning, error, connected, disconnected
    }
    private var connStatus: ConnectionStatus = .disconnected
    
    func status() -> ConnectionStatus {
        return self.connStatus
    }
    
    
///# Device Connection & Discovery
    func scanForDevices() {
        print("attemping to scan for devices")
        guard self.bluetoothReadyFlag else {
            print("bluetooth not ready yet")
            self.connStatus = .disabled
            return
        }
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    func connectToDevice(device: Desk) -> Bool {
        
        guard device.peripheral != nil else {
            print("connectToDevice(..) error: attempted to connect to nil peripheral,\nperipheral expired or not initialized")
            return false
        }
//messy...
        if self.zipdesk != nil {
            guard self.zipdesk!.setDesk(desk: device) else { return false }
        } else {
            self.zipdesk = ZGoZipDeskController(connectedDesk: device)
            guard self.zipdesk != nil else { return false }
        }
        
        centralManager?.connect(device.peripheral!)
    //MARK: check if connection times out... use timer
        // calls centralManager:didConnectPeripheral: on success
            // continue connection process by initializing ZGoZipDeskController
        // calls centralManager:didFailToConnectPeripheral:error: on failure
        // continue connection process by scanning for the desk again
        return true
    }
    
    
    func rediscoverDevice(device: Desk) {
    //MARK: initialize self.zipdesk here

        print("attempting to find and connect to current selected desk \(String(describing: self.zipdesk!.getDesk().name))")
        guard self.zipdesk!.getDesk().id > 0 else {//fixxxxxxxxx
            print("invalid deskID stored, or user hasn't input deskID yet")
            self.connStatus = .error
            return
        }
        guard self.bluetoothReadyFlag else {
            print("bluetooth not ready yet")
            self.connStatus = .disabled
            return
        }
// disconnect if needed to connect to a different desk
        if self.isDeskConnected {
            print("disconnecting from connected desk")
            self.isDeskConnected = false
            
            if self.zipdesk != nil {
                centralManager?.cancelPeripheralConnection(self.zipdesk!.getPeripheral())
            } else {
                print("error: bt.isDeskConnected was true, but bt.zipdesk not initialized yet")
            }
        }
        
        print("Scanning for peripherals with service: \(ZGoServiceUUID)")
        self.connStatus = .scanning
        // BT is on, targeted current desk is set, now scan for peripherals that match the CBUUID
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    
    
///# CoreBluetooth CentralManager Delegate functions
    
    ///# centralManagerDidUpdateState
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Checking Bluetooth status")
        switch central.state {
        // Bad cases: Bluetooth is not yet ready
        case .unknown:
            print("Bluetooth status is UNKNOWN")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        case .resetting:
            print("Bluetooth status is RESETTING")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        // Ideal case: Bluetooth is powered on, scan for desks
        case .poweredOn:
            DispatchQueue.main.async { () -> Void in (self.connStatus = .ready) }
            print("Bluetooth status is POWERED ON")
            // scan when user clicks the Connect To Desk button
            bluetoothReadyFlag = true
        // Exception:
        @unknown default:
            print("Bluetooth status EXCEPTION")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        }
    }
    
    
    ///# didDiscover peripheral
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
//MARK: ZIPDESK ID IMPLEMENTATION (delegate this to self.zipdesk)
        // Make unique manufacturer ID readable
        let rawData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3k, where 'k' is one digit of the 8 digit manufacturer ID.
        // 0x30 = 3 * 2^4 = 48
        var manufacturerDeskID : Int = 0
        for (index, digit) in rawData.enumerated() {
            manufacturerDeskID += Int(digit - 48) * Int(pow(10,Double(7-index)))
        }
        
        print("iOS discovered device w/ id# \(manufacturerDeskID)")
        
        DispatchQueue.main.async { () -> Void in
            // check saved devices for this device, update device peripheral if found
            if self.savedDevices.count > 0 {
                let foundIndex: Int? = self.savedDevices.firstIndex(
                        where: { (device) -> Bool in
                            device.id == manufacturerDeskID
                        })
                if foundIndex != nil {
                    self.savedDevices[foundIndex!].peripheral = peripheral
                    // if found in saved devices, skip the discovered devices check
                    return
                }
            }
            // check discovered devices for this device, update device peripheral if found
            if self.discoveredDevices.count > 0 {
               let foundIndex: Int? = self.discoveredDevices.firstIndex(
                        where: { (device) -> Bool in
                            device.id == manufacturerDeskID
                        })
                if foundIndex != nil {
                    self.discoveredDevices[foundIndex!].peripheral = peripheral
                    // if found in discovered devices, update but don't add a second reference
                    return
                }
            }
            // device wasn't found in discovered or saved so add it now
            self.discoveredDevices.append(Desk(deskID: manufacturerDeskID, deskPeripheral: peripheral, rssi: RSSI))
            
        }
//MARK: have now updated/added found device to saved or discovered devices.
        //What if we now want to automatically connect after discovery? Put that below:

    } // end didDiscover peripheral
    
    
    ///# didConnect peripheral
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        centralManager?.stopScan()
        peripheral.delegate = self
        DispatchQueue.main.async { () -> Void in
            self.connStatus = .connected
            self.isDeskConnected = true
        }
        print("successfully connected to desk \(String(describing: self.zipdesk?.getDesk().id))")
        self.zipdesk?.getPeripheral().discoverServices([ZGoServiceUUID])
    }
    
    ///# didFailToConnect peripheral
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        print("didFailToConnect peripheral, error:" + String(describing: error))
        DispatchQueue.main.async { () -> Void in
            self.connStatus = .error
            self.isDeskConnected = false
        }
        // clear zipdesk so it never references a dead connection
        self.zipdesk = nil
    }
    
    ///# didDisconnectPeripheral peripheral
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isDeskConnected = false
        DispatchQueue.main.async { () -> Void in
            self.connStatus = .disconnected
            self.isDeskConnected = false
        }
        print("device disconnected-")
        // Unintentional disconnection: attempt to reestablish connection with current desk
        if error != nil {
            print("desk disconnected with error\nattempting reconnection with current desk")
            print( "didDisconnect: reconnection successful? - " + String(self.connectToDevice(device: self.zipdesk!.getDesk())) )
        }
    }
    

    
    
    
///# CoreBluetooth Peripheral Delegate functions


    ///# didDiscoverServices
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == ZGoServiceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    ///# didDiscoverCharacteristicsFor service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            //print(characteristic)
            if characteristic.uuid == ZGoWriteCharacteristicUUID {
                self.zipdesk!.writeCharacteristic = characteristic
            } else if characteristic.uuid == ZGoNotifyCharacteristicUUID {
                self.zipdesk!.readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: self.zipdesk!.readCharacteristic!)
            }
        }
    }


    ///# didUpdateValueFor characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error:Error?) {
        guard error == nil else {
            print("didUpdateValueFor error: characteristic value update threw error - from notify or readValue(...)")
            return
        }
        guard characteristic.uuid == ZGoNotifyCharacteristicUUID else {
            print("didUpdateValueFor error: updated characteristic is not ZGoNotifyCharacteristic")
            return
        }
        self.zipdesk!.updateHeightInfo()
    }
    
    
    private func setTestMode() {
        self.savedDevices = [Desk(name: "Main Office Desk", deskID: 10009810), Desk(name: "Treadmill Home Office ", deskID: 54810), Desk(name: "Home Desk", deskID: 56781234), Desk(name: "Conference Room Third Floor Desk", deskID: 10005326), Desk(name: "Office 38 Desk", deskID: 38801661), Desk(name: "Home Monitor Arm", deskID: 881004)]
        self.discoveredDevices = [Desk(name: "Discovered ZipDesk", deskID: 10007189), Desk(name: "Discovered ZipDesk", deskID: 10004955), Desk(name: "Discovered ZipDesk", deskID: 10003210)]
    }
    
    
}// end ZGoBluetoothController

