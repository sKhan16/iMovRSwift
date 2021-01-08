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
                              CBCentralManagerDelegate,
                              CBPeripheralDelegate {
    
///# Persistent Device Data & Discovered Devices
    @Published var data: DeviceDataManager = DeviceDataManager()
    @Published var discoveredDevices: [Desk] = []
    
///# Current Desk
    @Published var isDeskConnected: Bool = false
    var zipdesk: ZGoZipDeskController = ZGoZipDeskController()
    
///# Current Monitor Arm
    // @Published var isMonitorArmConnected: Bool = false
    
///# Current Treadmill
    // @Published var isTreadmillConnected: Bool = false
    
    
///# Core Bluetooth
    private var centralManager: CBCentralManager?
    private var desiredPeripheral: CBPeripheral?
    private var bluetoothReadyFlag = false
    
    ///# Connection Status
    enum ConnectionStatus {
        case disabled, ready, scanning, error, connected, disconnected
    }
    
    private var connStatus: ConnectionStatus = .disconnected
    
    func status() -> ConnectionStatus {
        return self.connStatus
    }
    
    
    
///# Initializer
    override init() {
        super.init()
        
        // Create asynchronous queue for UI changes within Core Bluetooth methods
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
///# Test Mode Initializer - XCode Canvas Previews
    init?(previewMode: Bool) {
        guard previewMode else { return nil }
        super.init()
        self.setTestMode()
        
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    
    
    
///# Device Discovery and Connection functions
    
    func scanForDevices() {
        print("attemping to scan for devices")
        guard self.bluetoothReadyFlag else {
            print("--bluetooth not ready yet")
            self.connStatus = .disabled
            return
        }
        if self.connStatus != .connected {
            self.connStatus = .scanning
        }
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    func stopScan() {
        print("terminating device scan")
        guard self.bluetoothReadyFlag else {
            print("--bluetooth not ready yet")
            self.connStatus = .disabled
            return
        }
        if self.connStatus == .scanning {
            self.connStatus = .ready
        }
        centralManager?.stopScan()
    }
    
    
    func connectToDevice(device: Desk, savedIndex: Int) -> Bool {
        guard device.peripheral != nil else {
            print("bt.connectToDevice - ERROR: attempted to connect to nil peripheral,\n" +
                    "peripheral expired or not initialized")
            return false
        }
        guard device.peripheral?.state != .connected,
              device.peripheral?.state != .connecting else {
            print("bt.connectToDevice - ERROR: that device is already connected")
            return false
        }
        guard self.zipdesk.setDesk(connectedDesk: device) else {
            return false
        }
        
        print("connecting to device: \(device.name), id:\(device.id)")
            
        self.data.connectedDeskIndex = savedIndex
        self.data.setLastConnectedDesk(desk: device)
        
        centralManager?.connect(device.peripheral!)
        return true
        
    //MARK: check if connection times out... use timer
        // calls centralManager:didConnectPeripheral: on success
            // continue connection process by initializing ZGoZipDeskController
        // calls centralManager:didFailToConnectPeripheral:error: on failure
        // continue connection process by scanning for the desk again
    }
    
    
    func disconnectFromDevice(device: Desk, savedIndex: Int) -> Bool {
        guard self.isDeskConnected else {
            print("bt.disconnectFromDevice error: no desk device connected")
            return false
        }
        guard let connectedPeripheral: CBPeripheral = self.zipdesk.getPeripheral() else {
            print("error: bt.isDeskConnected was true, but bt.zipdesk not initialized yet")
            return false
        }
        guard (device.peripheral == connectedPeripheral) && (savedIndex == self.data.connectedDeskIndex) else {
            print("bt.disconnectFromDevice error: desk device does not match connectedDeskIndex & zipdesk peripheral")
            return false
        }
        print("disconnecting from connected desk")
        centralManager?.cancelPeripheralConnection(connectedPeripheral)
        self.isDeskConnected = false
        self.data.connectedDeskIndex = nil    //leave old index for easy reconnection
        return true
    }
    
    
    
///# CoreBluetooth CentralManager Delegate functions
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Checking Bluetooth status")
        
        switch central.state {
        
        // Ideal case: Bluetooth is powered on, scan for desks
        case .poweredOn:
            DispatchQueue.main.async { () -> Void in (self.connStatus = .ready) }
            print("Bluetooth status is POWERED ON")
            // scan when user clicks the Connect To Desk button
            bluetoothReadyFlag = true
            
        // Bad cases - Bluetooth is not yet ready
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
            
        // Exception
        @unknown default:
            print("Bluetooth status EXCEPTION")
            bluetoothReadyFlag = false
            DispatchQueue.main.async { () -> Void in (self.connStatus = .disabled) }
        }
    }
    
    
    ///# didDiscover peripheral
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Make unique ZGO manufacturer ID readable
        let rawData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3k, where 'k' is one digit of the 8 digit manufacturer ID.
        var manufacturerDeskID : Int = 0
        for (index, digit) in rawData.enumerated() {
            manufacturerDeskID += Int(digit - 48) * Int( pow(10,Double(7-index)) )
        }
        
        print("iOS discovered device w/ id# \(manufacturerDeskID)")
        
        DispatchQueue.main.async { () -> Void in
            
            // check saved devices for this device, update device peripheral if found
            if self.data.savedDevices.count > 0 {
                if let foundIndex: Int = self.data.savedDevices.firstIndex (
                        where: { (device) -> Bool in
                            device.id == manufacturerDeskID
                        }) {
                    self.data.savedDevices[foundIndex].peripheral = peripheral
                    // device previously saved, peripheral now stored locally-
                    // establish autoconnect to device if it was last connected
                    let thisSavedDevice: Desk = self.data.savedDevices[foundIndex]
                    
                    if thisSavedDevice.isLastConnected,
                       !self.isDeskConnected,
                       self.data.connectedDeskIndex == nil {
                        
                        let didConnect = self.connectToDevice(device: thisSavedDevice, savedIndex: foundIndex)
                        print("saved desk autoconnect successful? : \(didConnect)")
                        
                    }
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
        } // end async queue
        
    } // end didDiscover peripheral
    
    
    ///# didConnect peripheral
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        DispatchQueue.main.sync { () -> Void in
            self.connStatus = .connected
            self.isDeskConnected = true
        }
        print("successfully connected to desk \(String(describing: self.zipdesk.getDesk().id))")
        peripheral.discoverServices([ZGoServiceUUID])
    }
    
    ///# didFailToConnect peripheral
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        print("didFailToConnect peripheral, error:" + String(describing: error))
        DispatchQueue.main.sync { () -> Void in
            self.connStatus = .error
            self.isDeskConnected = false
            self.data.connectedDeskIndex = nil
        }
        // clear zipdesk so it never references a dead connection
        //self.zipdesk = nil
    }
    
    ///# didDisconnectPeripheral peripheral
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.sync { () -> Void in
            self.connStatus = .disconnected
            self.isDeskConnected = false
            self.data.connectedDeskIndex = nil
        }
        
        // disconnected unintentionally
        if error != nil {
            print("peripheral disconnected with error")
            // ensure autoconnect is enabled
            self.scanForDevices()
        } else {
            // Intentional disconnection
            print("bt.didDisconnectPeripheral - device disconnected")
        }
    }
    

    
    
/******************************************************************/
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
                self.zipdesk.writeCharacteristic = characteristic
            } else if characteristic.uuid == ZGoNotifyCharacteristicUUID {
                self.zipdesk.readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: self.zipdesk.readCharacteristic!)
            }
        }
        self.zipdesk.requestHeightsFromDesk()
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
        self.zipdesk.identifyMessage()
    }
    
    
    private func setTestMode() {
        
        self.data.savedDevices =
            [ Desk(name:"Main Office Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: true),
              Desk(name:"Treadmill Home Office",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false),
              Desk(name:"Home Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false),
              Desk(name:"Conference Room Third Floor Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false),
              Desk(name:"Office 38 Desk",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false),
              Desk(name:"Home Monitor Arm",deskID:10009810, presetHeights:[28.3,39.5,41.0,-1,-1,-1], presetNames:["Sit","Stand","Walk","PresetFour","PresetFive","PresetSix"], isLastConnected: false),
              ]
        
        self.discoveredDevices =
            [ Desk(name: "Discovered ZipDesk", deskID: 10007189, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false),
              Desk(name: "Discovered ZipDesk", deskID: 10004955, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false),
              Desk(name: "Discovered ZipDesk", deskID: 10003210, presetHeights:[-1,-1,-1,-1,-1,-1], presetNames: ["","","","","",""], isLastConnected: false)
            ]
        
        self.data.connectedDeskIndex = 0
    }
    
    
}// end ZGoBluetoothController

