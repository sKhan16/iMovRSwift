//
//  DeviceBluetoothController.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import SwiftUI
import CoreBluetooth


class DeviceBluetoothController: NSObject, ObservableObject,
                                 CBCentralManagerDelegate, CBPeripheralDelegate {
    

    
    ///# Externally modified variables
    
    // Current Desk Information
    @Published var deskWrap: ZGoZipDeskController?
    private var currentDesk: Desk?
    @Published var isDeskConnected: Bool = false
    @Published var deskHeight: Float = 0
    @Published var maxHeight: Float = 1
    @Published var minHeight: Float = 0
    @Published var connectionStatus: String = "No Devices Connected"
    @Published var connectionColor: Color = Color.primary

    //old
    private var deskPeripheral: CBPeripheral?
    
    // For desk scan feature in BTConnectView
    @Published var discoveredDevices: [Desk] = []
    
    
    ///#dont remember what this is for *****************************
    @State var deskUpdatedHeight = false
    
    
    ///# Local Bluetooth Objects
    private var centralManager: CBCentralManager?
    private var tempDeskPeripheral: CBPeripheral?
    
    private var writeCharacteristic, readCharacteristic: CBCharacteristic?
    private var bluetoothReadyFlag = false
    
    
    override init() {
        super.init()
        // Create asynchronous queue for UI changes within Core Bluetooth methods
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    
    func connectToDevice(peripheral: CBPeripheral?) {
        guard peripheral != nil else {
            print("error: attempted to connect to nil peripheral\nperipheral expired or wasn't initialized")
            return
        }
        
        centralManager?.connect(peripheral!)
    }
    
    
    func scanForDevices() {
        print("attemping to scan for devices")
        guard self.bluetoothReadyFlag else {
            print("bluetooth not ready yet")
            connectionStatus = "Turn On Bluetooth To Continue"
            connectionColor = Color.red
            return
        }
        // clear previously discovered devices
        // later only clear devices if their connection cannot be validated
        self.discoveredDevices = []
        // reset current desk for proper behavior in 'didDiscover peripheral' CoreBluetooth function
        
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    func startConnection() {
        guard self.currentDesk != nil else {
            print("bt.startConnection() error *** currentDesk undefined")
            return
        }
        print("attempting to find and connect to current selected desk \(self.currentDesk!.name)")
        guard self.currentDesk!.id > 0 else {
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
        // disconnect if needed to connect to a different desk
        if self.isDeskConnected {
            print("disconnecting from connected desk")
            self.isDeskConnected = false
          
            if self.deskWrap != nil {
                centralManager?.cancelPeripheralConnection(self.deskWrap!.peripheral)
            } else {
                print("error: bt.isDeskConnected was true, but bt.deskWrap not initialized yet")
            }
        }
        
        print("Scanning for peripherals with service: \(ZGoServiceUUID)")
        connectionStatus = "Scanning For Desks"
        connectionColor = Color.primary
        // BT is on, targeted current desk is set, now scan for peripherals that match the CBUUID
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    func updateDeskHeights() {
        if let temp = deskWrap?.getHeightInches() {
            DispatchQueue.main.async { () -> Void in
                self.deskHeight = temp
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
    
    
    ///# didDiscover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Make unique manufacturer ID readable
        let rawData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3k, where 'k' is one digit of the 8 digit manufacturer ID.
        // 0x30 = 3 * 2^4 = 48
        var manufacturerDeskID : Int = 0
        for (index, digit) in rawData.enumerated() {
            manufacturerDeskID += Int(digit - 48) * Int(pow(10,Double(7-index)))
        }
        
        print("iOS discovered device w/ id# \(manufacturerDeskID)")
        
        
        if discoveredDevices.count > 0 {
            // remember that it needs to allow manual connection to happen (if discovered desk is the one we are searching for)
            // can use this feature to bypass saving the peripheral reference and to make sure desk is in range when connecting...
            for (index, device) in discoveredDevices.enumerated() {
                //fix me
            }
        }
        DispatchQueue.main.async { () -> Void in
            self.discoveredDevices.append(Desk(deskID: manufacturerDeskID, deskPeripheral: peripheral, rssi: RSSI))
        }
        
        // I think we need to return here if scanForDesks is what lead to the desk being discovered... Or put the code after this guard into a different method only called with the currentDesk ID check.
        // Alternatively, put in a better check to see what function led to didDiscover. Then use it to connect or just save it in discovered.
        
        guard (self.currentDesk != nil) else {
            // peripheral was discovered during the scan process, exit code now
            print("*bt* no curr desk, skip manufac. ID chk")
            return
        }
        
        // scan is stopped after the guard statement. If first scanned desk happens to be the searched for currentDesk it won't discover any more desks, but this functionality must change

        // Begin connection if current discovered desk matches stored user selection
        guard manufacturerDeskID == self.currentDesk!.id else {
            print("Desk id \(String(manufacturerDeskID)) did not match selected desk id \(String(self.currentDesk!.id))")
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
        print("Connecting to desk with ID:\n \(rawData)")
        
        deskPeripheral = peripheral
        // Must set delegate of peripheralZGoDesk to ViewController(self)
        // Stop scanning for peripherals to save battery life
        centralManager?.stopScan()
        // Connect to the discovered peripheral
        //print("Connecting to peripheral")
        centralManager?.connect(deskPeripheral!)
    } // end didDiscover peripheral
    
    
    // didConnect: Invoked when a peripheral is connected successfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Connected To Desk"
            self.connectionColor = Color.green
            self.isDeskConnected = true
        }
        print("successfully connected to desk \(String(describing: self.currentDesk?.id))")

        deskPeripheral?.discoverServices([ZGoServiceUUID])
    }
    
    
    // didDisconnectPeripheral: When the peripheral disconnects, start scanning on BT again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected; now scanning")
        //catch error here?
        
        self.isDeskConnected = false
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Desk Disconnected"
            self.connectionColor = Color.primary
        }
        
        // Unintentional disconnection: attempt to reestablish connection with current desk
        if error != nil {
            print("desk disconnected with error\nattempting reconnection with current desk")
            centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
        }
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
            
        }
        
        // Initialize deskWrap to interact with desk later
        DispatchQueue.main.async { () -> Void in
            self.deskWrap = ZGoZipDeskController(peripheral: self.deskPeripheral!, id: -1, write: self.writeCharacteristic!, read: self.readCharacteristic!)
        }
        
    } // END func peripheral(... didDiscoverCharacteristicsFor service
    
    
    // Called when readCharacteristic value is updated by the peripheral
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error:Error?) {
        guard error == nil else {
            print("didUpdateValueFor error: characteristic value update threw error - from notify or readValue(...)")
            return
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

