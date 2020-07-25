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
//import Darwin  ### old code needed Darwin for power (math function)


class ZGoBluetoothController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    // Published variables (update UI when changed)
    
    
    @Published var currentHeight: Float = 0
    @Published var maxHeight: Float = 1
    @Published var minHeight: Float = 0
    
    @Published var connectionStatus: String = "Connect to a Desk"
    @Published var connectionColor: Color = Color.primary
    @Published var isConnected = false
    @Published var currDeskID: Int = 0
    
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
    
    // centralManager handles iOS Bluetooth interactions
    var centralManager: CBCentralManager?
    // deskPeripheral and deskWrap represent the connected desk
    var deskPeripheral: CBPeripheral?
    
    var writeCharacteristic, readCharacteristic: CBCharacteristic?
    
    var bluetoothReadyFlag = false
    
    // MARK: Bluetooth function handlers and rest go below:
    
    // Connect to Desk button onClick function
    //@IBAction (function below)
    func startConnection() {
        guard self.currDeskID > 0 else {
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
        // MARK: (currHeight*10.0).rounded(.down)/10.0) --rounded to 1 decimal point--
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
    
    /*
     MARK: Bluetooth Implementation after view is loaded
     To scan for desk, wait for user to activate bluetooth on their phone;
     should direct user via asychronous UI changes in the case statements
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Only want to scan for peripherals when the Bluetooth manager state is .poweredOn
        print("Checking Bluetooth status")
        switch central.state {
            
            // Bad cases: Bluetooth is not yet ready
        // NOTE:Make these cases update the UI so user knows to enable Bluetooth
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
    
    ///Next: centralManager methods for interacting with the bluetooth peripherals.
    
    // didDiscover(...): Discover the peripherals of interest (ZGo desks in this case)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // MARK: Verify manufacturer deskID matches user input deskID
        var manufacturerData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3y, where 'y' is one digit of the 8 digit manufacturer unique ID. 48 = 3*16
        // manufacturerData must be converted for comparison to QR code sticker number
        for index in manufacturerData.indices {
            manufacturerData[index] -= 48;
        }
        // Store manufacturer data array into one int
        var manufacturerDeskID : Int = 0
        for (index, digit) in manufacturerData.enumerated() {
            // manufacturerData is littleEndian and size 8.
            manufacturerDeskID += Int(digit) * Int(pow(10,Double(7-index)))
            print("index:\(index), sum: \(manufacturerDeskID)")
        }
        print("After, fixed \(manufacturerDeskID)")
        
        guard manufacturerDeskID == self.currDeskID else {
            print("Desk \(String(manufacturerDeskID)) did not match user-stored value \(String(self.currDeskID))")
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
        print("Manufacturer Data: "); print(manufacturerData)
        if ((peripheral.name) != nil) {
            print("Discovered peripheral name: \(peripheral.name!)")
            
        } else {
            print("Discovered peripheral name = nil, perhaps connected to wrong peripheral?")
        }
        
        deskPeripheral = peripheral
        // Must set delegate of peripheralZGoDesk to ViewController(self)
        deskPeripheral?.delegate = self
        // Stop scanning for peripherals to save battery life
        centralManager?.stopScan()
        // Connect to the discovered peripheral
        print("Connecting to peripheral")
        centralManager?.connect(deskPeripheral!)
        
    } // end didDiscover peripheral
    
    
    // didConnect: Invoked when a peripheral is connected successfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Connected To Desk"
            self.connectionColor = Color.green
        }
        print("Connected; now discovering services of \(String(describing: deskPeripheral?.name))")
        deskPeripheral?.discoverServices([ZGoServiceUUID])
    }
    
    
    // didDisconnectPeripheral: When the peripheral disconnects, start scanning on BT again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected; now scanning")
        DispatchQueue.main.async { () -> Void in
            self.connectionStatus = "Desk Disconnected"
            self.connectionColor = Color.primary
        }
        // Start scanning for (ZGo) desks again
        //MARK:~~~Maybe this should look for paired devices before scanning for new ones~~~
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID])
    }
    
    
    // didDiscoverServices: Check for services on the peripheral - this will change in final
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            if service.uuid == ZGoServiceUUID {
                // No need to save a reference to the service because we only interact with the characteristics of this service. We directly reference those.
                //print("Service: \(service.uuid)")
                
                // look for characteristics of interest within services of interest
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
        }
    }
    
    
    // didDiscoverCharacteristicsFor:
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Discovering services of \(String(describing: deskPeripheral?.name))")
        
        for characteristic in service.characteristics! {
            //print(characteristic)
            if characteristic.uuid == ZGoWriteCharacteristicUUID {
                writeCharacteristic = characteristic
            }
            
            if characteristic.uuid == ZGoNotifyCharacteristicUUID {
                readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: readCharacteristic!)
                // STEP 11: subscribe to a single notification
                // for characteristic of interest;
                // "When you call this method to read
                // the value of a characteristic, the peripheral
                // calls ... peripheral:didUpdateValueForCharacteristic:error:
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
}
    















//MARK: Old code to be imported
/*

import CoreBluetooth
import Darwin


class FirstViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var deskID: Int?

    
    var pickerData: [String] = [String]()
    
    // ["Sitting", "Standing", "Walking"]
    var presets: [(name: String, height: Double)] = [(String, Double)]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view:
        
        connStatus.text = "Input Desk ID"
        connStatus.textColor = UIColor.black
        
        self.loadPresets()
        self.loadPresetTitles()
        
        print("intial preset size at startup: \(presets.count)")
        // Height slider section
        heightLabel.text = String(Int (heightSlider.value) )
        //Makes the slider vertical
        heightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi/2))
        
        //MARK: Bluetooth Implementation in viewDidLoad()
        // Creates a background queue to manage UI interactions behind the Bluetooth functions
        
        
    } // End viewDidLoad()
    
    
    // If memory is full clear up some space
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functions associated with UI elements
    @IBAction func createPreset(_ sender: Any) {
        print("Creating preset")
        self.performSegue(withIdentifier: "PresetSegue", sender: self)
    }
    /* Unneeded due to nature of bluetooth code - height only updates when desk notifies that it has changed.
     @IBAction func sliderSlid(_ sender: UISlider) {
     //updateHeightLabel()
     heightLabel.text = String(Int (heightSlider.value))
     }
     
     @IBAction func upClick(_ sender: Any) {
     heightSlider.value += 1
     updateHeightLabel()
     }
     
     @IBAction func downClick(_ sender: Any) {
     heightSlider.value -= 1
     updateHeightLabel()
     }
     */
    
    
    
    @IBAction func unwindToFirstViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
        print(self.presets)
    }
    
    
    
    //loads default values for presets
    func loadPresets() {
        self.presets.append((name: "Sitting", height: zSitDef))
        self.presets.append((name: "Standing", height: zStandDef))
        self.presets.append((name: "Walking", height: zWalkDef))
    }
    
    func loadPresetTitles() {
        sittingPreset.setTitle( String(presets[sitIndex].height), for: UIControl.State.normal)
        
        standingPreset.setTitle(String(presets[standIndex].height), for: UIControl.State.normal)
        
        walkingPreset.setTitle(String(presets[walkIndex].height), for: UIControl.State.normal)
    }
    
    
    // MARK:
    // Up button actions
    @IBAction func onTouch_UpButton(_ sender: Any) {
        deskWrap?.raiseDesk()
    }
    @IBAction func onReleaseInside_UpButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func onReleaseOutside_UpButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func onTouchDragAway_UpButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    // Down button actions: (yes i could tie the actions with the button events but I'll do that later)
    @IBAction func onTouch_DownButton(_ sender: Any) {
        deskWrap?.lowerDesk()
    }
    @IBAction func onReleaseInside_DownButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    @IBAction func onReleaseOutside_DownButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func onTouchDragAway_DownButton(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    // Preset button actions
    // Preset0
    @IBAction func TouchDown_Preset0(_ sender: UIButton) {
        deskWrap?.moveToHeight(PresetHeight: self.presets[sitIndex].height)
    }
    @IBAction func ReleaseInside_Preset0(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func ReleaseOutside_Preset0(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    // Preset1
    @IBAction func TouchDown_Preset1(_ sender: UIButton) {
        //print("Button title: " + sender.currentTitle)
        deskWrap?.moveToHeight(PresetHeight: self.presets[standIndex].height)
    }
    @IBAction func ReleaseInside_Preset1(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func ReleaseOutside_Preset1(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    // Preset2
    @IBAction func TouchDown_Preset2(_ sender: UIButton) {
        deskWrap?.moveToHeight(PresetHeight: self.presets[walkIndex].height)
    }
    @IBAction func ReleaseInside_Preset2(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    @IBAction func ReleaseOutside_Preset2(_ sender: Any) {
        deskWrap?.releaseDesk()
    }
    
    
} // MARK: End of FirstViewController


// allows the use of a done button
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

 */
