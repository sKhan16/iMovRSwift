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
    var zipdesk: ZGoZipDeskController = ZGoZipDeskController()
    
///# Current Monitor Arm
    // @Published var monitorArm: ___ = ___()
    
///# Current Treadmill
    // @Published var treadmill: ___ = ___()
    var treadmill: TreadmillController = TreadmillController()
    
///# Core Bluetooth
    @Published var bluetoothEnabled: Bool = false
    private var centralManager: CBCentralManager?
    
    @Published var connectingIndex: Int?
    private var connectionTimeoutTimer: Timer?
    
    private var scanTimer: Timer?
    private var signalStrengthTimer: Timer?
    
///# Initializer
    override init() {
        super.init()
        
        // Create asynchronous queue for UI changes within Core Bluetooth methods
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        
        signalStrengthTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        )
        { timer in
            self.readConnectedRSSI()
        }
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
    
    func scanForDevices(repeating: Bool)
    {
        print("Scanning for devices:")
        guard self.bluetoothEnabled else {
            print(" ! can't scan - phone bluetooth disabled")
            return
        }
        //scan for 150ms, stop; repeat after 3s
        if scanTimer != nil { scanTimer!.fire() }
        else
        {
            scanTimer = Timer.scheduledTimer(
                withTimeInterval: 3.0,
                repeats: repeating
            )
            { scan_timer in
                if self.bluetoothEnabled
                {
                    self.centralManager?.scanForPeripherals(
                        withServices: [ZGoServiceUUID],
                        options: [CBCentralManagerScanOptionAllowDuplicatesKey : true]
                    )
                }
                _ = Timer.scheduledTimer(
                    withTimeInterval: 0.15,
                    repeats: false
                ){ stop_timer in
                    self.centralManager?.stopScan()
                    stop_timer.invalidate()
                }
            }
            
            scanTimer!.fire()
        }
        
    }
    
    
    func stopScan()
    {
        print("terminating device scan")
//        guard self.bluetoothEnabled else {
//            print("-bluetooth not ready yet")
//            return
//        }
        self.scanTimer?.invalidate()
        self.scanTimer = nil
        self.centralManager?.stopScan()
    }
    
    
    func readConnectedRSSI()
    {
        if let connectedIndex: Int = data.connectedDeskIndex //"index != nil"
        {
            if let peripheral: CBPeripheral = data.savedDevices[connectedIndex].peripheral
            {
                if peripheral.state == CBPeripheralState.connected
                {
                    peripheral.delegate = self
                    peripheral.readRSSI()
                }
                else
                {
                    print("error in bt.readConnectedRSSI\n  connectedDeskIndex peripheral not connected")
                }
            }
            else
            {
                print("error in bt.readConnectedRSSI\n  no peripheral at data.connectedDeskIndex")
            }
        }
    }
    
    public func isInRange(rssi: NSNumber?) -> Bool
    {
        return ((rssi as? Double) ?? -1000.0) > -100.0
    }
    
    
    func connectToDevice(device: Desk, savedIndex: Int) -> Bool
    {
        guard device.peripheral != nil else
        {
            print("bt.connect -- ERROR: attempted to connect to nil peripheral")
            return false
        }
        guard self.connectingIndex == nil else
        {
            print("bt.connect error: a device is currently connecting")
            return false
        }
        guard savedIndex != self.data.connectedDeskIndex else
        {
            print("bt.connect -- ERROR: that device is already connected")
            return false
        }
        guard device.peripheral?.state != .connected,
              device.peripheral?.state != .connecting else
        {
            print("bt.connectToDevice error: device peripheral already connecting/ed but mismatches connectedDeskIndex")
            return false
        }
        guard device.inRange else
        {
            print("bt.connectToDevice error: device peripheral is out of range")
            return false
        }
        
        self.connectingIndex = savedIndex
        self.data.setLastConnectedDesk(desk: device)
        centralManager?.connect(device.peripheral!)
        connectionTimeoutTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: false
        )
        { timer in
            if self.connectingIndex != nil
            {
                let timeoutDevice = self.data.savedDevices[self.connectingIndex!]
                if timeoutDevice.peripheral != nil,
                   timeoutDevice.peripheral!.state != .connected
                {
                    self.centralManager?.cancelPeripheralConnection(timeoutDevice.peripheral!)
                    self.connectingIndex = nil
//                    self.data.setLastConnectedDesk(desk: timeoutDevice, disable: true)
                    print("bt.connect: device connection timed out")
                }
            }
            timer.invalidate()
        }
        print("connecting to this device: \(device.name), id:\(device.id)")
        // calls centralManager:didConnectPeripheral: on success
        // continue connection process by initializing ZGoZipDeskController
        // calls centralManager:didFailToConnectPeripheral:error: on failure
        // continue connection process by scanning for the desk again
        return true
    } // end connectToDevice
    
    
    func disconnectFromDevice(device: Desk, savedIndex: Int) -> Bool
    {
        guard device.peripheral != nil else {
            print("bt.disconnect ERROR: nil peripheral")
            return false
        }
        guard (device.peripheral!.state == .connected) || (device.peripheral!.state == .connecting) else {
            print("bt.disconnect ERROR: peripheral not connected or connecting")
            return false
        }
        guard savedIndex == self.data.connectedDeskIndex else {
            print("bt.disconnectFromDevice error: desk device does not match connectedDeskIndex / current zipdesk peripheral")
            return false
        }
        print("disconnecting from connected desk")
        self.data.setLastConnectedDesk(desk: device, disable: true)
        centralManager?.cancelPeripheralConnection(device.peripheral!)
        return true
    }
    
    
    
    
///# CoreBluetooth CentralManager Delegate functions
    
    
    func centralManagerDidUpdateState(
        _ central: CBCentralManager
    )
    {
        switch central.state {
        
        // Ideal case: Bluetooth is powered on, scan for desks
        case .poweredOn:
            print("Bluetooth status is POWERED ON.")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = true
                self.scanForDevices(repeating: true)
            }
            
        // Bad cases - Bluetooth is not yet ready
        case .unknown:
            print("Bluetooth status is UNKNOWN!")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = false
            }
        case .resetting:
            print("Bluetooth status is RESETTING!")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = false
            }
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED!")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = false
            }
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED!")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = false
            }
        case .poweredOff:
            print("Bluetooth status is POWERED OFF!")
            DispatchQueue.main.sync {
                self.bluetoothEnabled = false
                if let index: Int = self.data.connectedDeskIndex {
                    self.data.connectedDeskIndex = nil
                    self.disconnectFromDevice (
                        device: self.data.savedDevices[index],
                        savedIndex: index
                    )
                }
            }
            
        // Exception
        @unknown default:
            print("Bluetooth status EXCEPTION!")
            DispatchQueue.main.sync { () -> Void in
                self.bluetoothEnabled = false
            }
        }
    }
    
    let WEAK_SIGNAL: NSNumber = 127
    
    ///# didDiscover peripheral
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ){
        // Make unique ZGO manufacturer ID readable
        let rawData: [UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3k, where 'k' is one digit of the ID
        var manufacturerDeskID: Int = 0
        for (index, digit) in rawData.enumerated() {
            manufacturerDeskID += Int(digit - 48) * Int(pow(10,Double(7-index)))
        }
        //print("iOS discovered device w/ id# \(manufacturerDeskID) rssi \(RSSI) in range? \(self.isInRange(rssi: RSSI) ? "yes":"no")")
        
        
        DispatchQueue.main.sync { () -> Void in
            if self.data.savedDevices.count > 0
            {
                if let foundIndex: Int = self.data.savedDevices.firstIndex (
                        where: { (device) -> Bool in
                            device.id == manufacturerDeskID
                        })
                {
                    //device signal is too weak to read
                    if RSSI == WEAK_SIGNAL,
                       foundIndex != self.data.connectedDeskIndex
                    {
                        self.data.savedDevices[foundIndex].peripheral = nil
                        self.data.savedDevices[foundIndex].rssi = nil
                        self.data.savedDevices[foundIndex].inRange = false
                        return
                    }
                    //device signal is readable but may be in or out of range
                    self.data.savedDevices[foundIndex].peripheral = peripheral
                    self.data.savedDevices[foundIndex].rssi = RSSI
                    self.data.savedDevices[foundIndex].inRange = self.isInRange(rssi: RSSI)
                    
                    if self.data.devicePickerIndex == nil {
                        _=self.data.setPickerIndex(decrement: true)
                    }

                    let autoconnectDevice: Desk = self.data.savedDevices[foundIndex]
                    if autoconnectDevice.isLastConnected,
                       self.data.connectedDeskIndex == nil,
                       RSSI != WEAK_SIGNAL,
                       self.isInRange(rssi: RSSI)
                    {
                        _ = self.connectToDevice(device: autoconnectDevice, savedIndex: foundIndex)
                        print("autoconnecting to device")
                        
                    }
                    return
                }
            }
            if self.discoveredDevices.count > 0 {
               if let foundIndex: Int = self.discoveredDevices.firstIndex(
                        where: { (device) -> Bool in
                            device.id == manufacturerDeskID
                        })
               {
                    if RSSI == WEAK_SIGNAL
                    {
                        self.discoveredDevices.remove(at: foundIndex)
                    } else
                    {
                        self.discoveredDevices[foundIndex].peripheral = peripheral
                        self.discoveredDevices[foundIndex].rssi = RSSI
                        self.discoveredDevices[foundIndex].inRange = self.isInRange(rssi: RSSI)
                    }
                    return
                }
            }
            if RSSI != WEAK_SIGNAL
            {
                self.discoveredDevices.append(
                    Desk(deskID: manufacturerDeskID,
                        deskPeripheral: peripheral,
                        rssi: RSSI)
                )
            }
        }
        
    } //end didDiscover peripheral
    
    
    
    ///# didConnect peripheral
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    )
    {
        peripheral.delegate = self
        print("-> bt.didConnect")
        DispatchQueue.main.sync { () -> Void in
            guard self.connectingIndex != nil else {
                print("didConnect ERROR: connectingIndex was unstaged. ")
                return
            }
            guard peripheral == data.savedDevices[connectingIndex!].peripheral else {
                print("didConnect ERROR: peripherals do not match")
                return
            }
            guard self.zipdesk.setDesk (
                    soonConnectedDesk: data.savedDevices[connectingIndex!]
            ) else {
                print("didConnect ERROR: rejected by zipdesk.setDesk")
                return
            }
            
            // set UI indices to represent newly connected desk
            self.data.connectedDeskIndex = self.connectingIndex
            self.data.devicePickerIndex = self.connectingIndex
            self.connectingIndex = nil
            self.zipdesk.getPeripheral()!.discoverServices([ZGoServiceUUID])
            
            print("Successfully connected to desk # \(self.zipdesk.getDesk().id).")
            print("bt.didConnect: disconnecting from all other desks")
            for (index, device) in data.savedDevices.enumerated() {
                // find improperly connected devices
                if index != self.data.connectedDeskIndex,
                   device.peripheral != nil,
                   (device.peripheral!.state == .connected || device.peripheral!.state == .connecting)
                {
                    centralManager?.cancelPeripheralConnection(device.peripheral!)
                }
            }
        }
    } //end didConnect
    
    
    
    ///# didFailToConnect peripheral
    func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    )
    {
        print("didFailToConnect peripheral, error:" + String(describing: error))
    }
    
    
    
    ///# didDisconnectPeripheral peripheral
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    )
    {
        DispatchQueue.main.sync { () -> Void in
            if self.data.connectedDeskIndex != nil,
               peripheral == data.savedDevices[data.connectedDeskIndex!].peripheral
            {
                print("bt.didDisconnect -- nullified connectedDeskIndex")
                self.data.connectedDeskIndex = nil
            }
        }
        // ensure discovery and autoconnect are enabled
        self.scanForDevices(repeating: true)
        
        // disconnected unintentionally
        if error != nil {
            print("peripheral disconnected with error")
        } else {
            // Intentional disconnection
            print("bt.didDisconnectPeripheral - device disconnected without error")
        }
    }
    
    
    
    
//******************************************************************//
//******************************************************************//
    
///# CoreBluetooth Peripheral Delegate Functions
    
    
    
    ///# didReadRSSI
    func peripheral(
        _ peripheral: CBPeripheral,
        didReadRSSI RSSI: NSNumber,
        error: Error?
    )
    {
        // Invalidate device if readRSSI returns an error
        if error != nil
        {
            print("error reading connected desk RSSI:\n###\n " + (error!.localizedDescription) + "\n###")
            //disconnect if this was the connected device (and clear 'bt.zipdesk')
            //notify user via UI / state changes "Available"->"Not Available"
            return
        }
        
        if data.connectedDeskIndex != nil
        {
            let cdi: Int = data.connectedDeskIndex!
            DispatchQueue.main.sync
            { () -> Void in
                data.savedDevices[cdi].rssi = RSSI
                data.savedDevices[cdi].inRange = self.isInRange(rssi: RSSI)
            }
            if RSSI == WEAK_SIGNAL || !self.isInRange(rssi:RSSI)
            {
                disconnectFromDevice(
                    device: data.savedDevices[cdi],
                    savedIndex: cdi)
            }
        }
        
//        //DO STUFF:
//        //hopefully the change to the published data.savedDevices will update UI state automatically
//
//        // Locate connected device in savedDevices
//        if let index: Int = self.data.savedDevices.firstIndex(
//            where: { device -> Bool in
//                peripheral == device.peripheral
//            }
//        )
//        {
//            // disconnect/remove peripheral if didReadRSSI failed with error
//            // case: device is much too far away, user should interact with this device
//            //
//            guard error != nil else {
//                print("didReadRSSI error")
////                if peripheral.state == .connected {
////                    centralManager?.cancelPeripheralConnection(peripheral)
////                }
////                print("deleting peripheral reference")
////                self.data.savedDevices[index].peripheral = nil
//                return
//            }
//            self.data.savedDevices[index].rssi = RSSI
//            self.data.savedDevices[index].inRange = self.isInRange(rssi: RSSI)
//        }
//
//        else if let index: Int = self.discoveredDevices.firstIndex(
//            where: { device -> Bool in
//                peripheral == device.peripheral
//            }
//        )
//        {
//            guard error != nil else {
//                if peripheral.state == .connected {
//                    centralManager?.cancelPeripheralConnection(peripheral)
//                }
//                print("deleting peripheral reference")
//                self.discoveredDevices[index].peripheral = nil
//                return
//            }
//            self.discoveredDevices[index].rssi = RSSI
//            self.discoveredDevices[index].inRange = self.isInRange(rssi: RSSI)
//        }
    }
    
    
    
    ///# didDiscoverServices
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    )
    {
        for service in peripheral.services! {
            if service.uuid == ZGoServiceUUID {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    
    ///# didDiscoverCharacteristicsFor service
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    )
    {
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
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error:Error?
    )
    {
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
    
    
    
    
    
    
///# Populate data for test-mode previews of app
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

