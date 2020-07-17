//
//  ZGoBluetoothController.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import CoreBluetooth
//import Darwin  ### old code needed Darwin for power (math function)


class ZGoBluetoothController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    // Published variables
    @Published var isConnected = false
    @Published var deskWrap: ZGoDeskPeripheral?
    // shakeel and I need to implement UserData (or userData if struct)
    @Published var userData: UserObservable?
    //delete this struct after Shakeel merges his UserObservable class
    struct UserObservable {
        var deskID: String? = "10008002"
        
    }
    
    //MARK: Bluetooth Objects
    
    // centralManager handles iOS Bluetooth interactions
    var centralManager: CBCentralManager?
    // peripheralDesk and deskWrap represent the connected desk
    var peripheralDesk: CBPeripheral?
    var writeCharacteristic, readCharacteristic: CBCharacteristic?
    var BluetoothReadyFLAG: Bool = false
    
    
    // MARK: Bluetooth function handlers and rest go below:
    
    // Connect to Desk button onClick function
    //@IBAction (function below)
    func connectDeskClick(_ sender: Any) {
        guard userData?.deskID != nil && userData?.deskID?.count == 8 else {
            print("invalid input")
//            connStatus.text = "Invalid Input"
//            connStatus.textColor = UIColor.red
            return
        }
        //deskID = Int(deskIDInput.text!)!
        checkDeskID()
    }
    
    func checkDeskID() {
        // tell central to start scanning, eventually checking discovered peripheral with the deskID
        guard BluetoothReadyFLAG else {
            print("turn bluetooth on to continue")
//            connStatus.text = "Turn Bluetooth On To Continue"
//            connStatus.textColor = UIColor.red
            return
        }
        print("Scanning for peripherals with service: \(ZGoServiceUUID)")
//        connStatus.text = "Scanning For Desks"
//        connStatus.textColor = UIColor.black
        // BT is on, now scan for peripherals that match the CBUUID
        centralManager?.scanForPeripherals(withServices: [ZGoServiceUUID]);
    }
    
    func updateHeightLabel() {
        // Update current height
        guard let currHeight:Double = deskWrap?.getHeightInches() else { return }
//        heightSlider.setValue(Float(currHeight), animated: true)
//        heightLabel.text = String(format: "%.1f", (currHeight*10.0).rounded(.down)/10.0) // only one decimal point printed
        //Update max and min height
        guard let maxHeight:Double = deskWrap?.getMaxHeightInches() else { return }
        guard let minHeight:Double = deskWrap?.getMinHeightInches() else { return }
//        heightSlider.maximumValue = Float(maxHeight)
//        heightSlider.minimumValue = Float(minHeight)
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
            BluetoothReadyFLAG = false
        case .resetting:
            print("Bluetooth status is RESETTING")
            BluetoothReadyFLAG = false
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
            BluetoothReadyFLAG = false
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
            BluetoothReadyFLAG = false
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
            BluetoothReadyFLAG = false
            DispatchQueue.main.async { () -> Void in
//                self.connStatus.text = "Turn Bluetooth On To Continue"
//                self.connStatus.textColor = UIColor.red
            }
        // Ideal case: Bluetooth is powered on, scan for desks
        case .poweredOn:
            DispatchQueue.main.async { () -> Void in
//                self.connStatus.text = "Input Desk ID"
//                self.connStatus.textColor = UIColor.black
            }
            print("Bluetooth status is POWERED ON")
            // scan when user clicks the Connect To Desk button
            BluetoothReadyFLAG = true
            
        // Exception:
        @unknown default:
            print("Bluetooth status EXCEPTION")
            BluetoothReadyFLAG = false
        }
    }
    
    ///Next: centralManager methods for interacting with the bluetooth peripherals.
    
    // didDiscover(...): Discover the peripherals of interest (ZGo desks in this case)
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // MARK: Verify advertising data matches user input
        var manufacturerData:[UInt8] = [UInt8]((advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)!)
        // Bytes are stored as 0x3y, where 'y' is one digit of the 8 digit manufacturer unique ID. 48 = 3*16
        // manufacturerData must be converted for comparison to QR code sticker number
        print("Before \(manufacturerData)")
        for index in manufacturerData.indices {
            manufacturerData[index] -= 48;
        }
        print("Before, fixed \(manufacturerData)")
        // Store manufacturer data array into one int
        var manufacturerDeskID : Int = 0
        for (index, digit) in manufacturerData.enumerated() {
            // manufacturerData is littleEndian and size 8.
            manufacturerDeskID += Int(digit) * Int(pow(10,Double(7-index)))
            print("index:\(index), sum: \(manufacturerDeskID)")
        }
        print("After, fixed \(manufacturerDeskID)")
        
        guard (Int((userData?.deskID)!) != nil) && (Int((userData?.deskID)!)! == manufacturerDeskID) else {
            print("Desk \(String(manufacturerDeskID)) did not match")
            DispatchQueue.main.async { () -> Void in
//                self.connStatus.text = "Discovered Desk(s) Did Not Match ID"
//                self.connStatus.textColor = UIColor.red
            }
            return
        }
        
        print("Manufacturer Data: "); print(manufacturerData)
        if ((peripheral.name) != nil) {
            print("Discovered peripheral name: \(peripheral.name!)")
            
        } else {
            print("Discovered peripheral name = nil, perhaps connected to wrong peripheral?")
        }
        
        peripheralDesk = peripheral
        // Must set delegate of peripheralZGoDesk to ViewController(self)
        peripheralDesk?.delegate = self
        // Stop scanning for peripherals to save battery life
        centralManager?.stopScan()
        // Connect to the discovered peripheral
        print("Connecting to peripheral")
        centralManager?.connect(peripheralDesk!)
        
    } // end didDiscover peripheral
    
    
    // didConnect: Invoked when a peripheral is connected successfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DispatchQueue.main.async { () -> Void in
//            self.connStatus.text = "Desk Connected"
//            self.connStatus.textColor = UIColor.green
        }
        print("Discovering services of \(String(describing: peripheralDesk?.name))")
        peripheralDesk?.discoverServices([ZGoServiceUUID])
    }
    
    
    // didDisconnectPeripheral: When the peripheral disconnects, start scanning on BT again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected; now scanning")
        DispatchQueue.main.async { () -> Void in
//            self.connStatus.text = "Desk Disconnected"
//            self.connStatus.textColor = UIColor.red
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
        
        print("Discovering services of \(String(describing: peripheralDesk?.name))")
        
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
        deskWrap = ZGoDeskPeripheral(peripheral: peripheralDesk!, write: writeCharacteristic!, read: readCharacteristic!)
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
        DispatchQueue.main.async { () -> Void in
            self.updateHeightLabel()
        }
    }
    
}


//MARK: Bluetooth Implementation - Desk Interaction

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
        
        let readArray: [UInt8] = [UInt8](readData)
        //print(readArray)
        /*
         let readIntArray: [Int] = []
         for (index,currByte) in readArray[1..<(readArray.endIndex - 1)] {
         
         }
         // Verify checksum of message:
         let chksum: [Int] = [Int](readArray[1..<(readArray.endIndex-1)])
         guard chksum.reduce(0,+) & 0xFF == readArray.last! else {
         print("readData checksum invalid")
         return
         }
         func convertType(typeIn: [Int]) -> [UInt8] {
         return [UInt8](arrayLiteral: UInt8(typeIn[0]),UInt8(typeIn[1]))
         }
         */
        if readArray[0...2] == [0x5A,0x09,0x21] {
            guard readArray.count == 10 else {
                print("readData count invalid")
                return
            }
            print("successfully detected message: Table Height Information")
            self.deskHeight = [readArray[4],readArray[3]]
            self.deskMinHeight = [readArray[6],readArray[5]]
            self.deskMaxHeight = [readArray[8],readArray[7]]
            /*self.deskHeight = convertType(typeIn: Array(readArray[3...4]))
             self.deskMinHeight = convertType(typeIn: Array(readArray[5...6]))
             self.deskMaxHeight = convertType(typeIn: Array(readArray[7...8]))
             */
        } else if readArray[0...1] == [0x5A,0x06] {
            guard readArray.count == 7 else {
                print("readData count invalid")
                return
            }
            //print("successfully detected message: Movement/Status Change Update")
            //self.deskHeight = convertType(typeIn: Array(readArray[3...4]))
            self.deskHeight = [readArray[4],readArray[3]]
            
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
    
    func getHeightInches() -> Double? {
        return self.mmBits2inch(HeightBits: self.deskHeight)
    }
    func getMinHeightInches() -> Double? {
        return self.mmBits2inch(HeightBits: self.deskMinHeight)
    }
    func getMaxHeightInches() -> Double? {
        return self.mmBits2inch(HeightBits: self.deskMaxHeight)
    }
    
    // Convert height in millimeters to inches
    private func mmBits2inch(HeightBits: [UInt8]?)->Double? {
        guard (HeightBits != nil) && (HeightBits?.count == 2) else {
            print("mmToInch error")
            return nil
        }
        return Double(Int(HeightBits![1])<<8 + Int(HeightBits![0])) / 25.4
    }
    
    // Convert height in inches to millimeters in [UInt8] 2 byte array form
    private func inch2mmBits(HeightIn: Double)->[UInt8] {
        // try rounding up with bitwise logic to sync better to desk
        let Height = Int(HeightIn * 25.4)
        return [(UInt8)(Height & 0xFF), (UInt8)((Height>>8) & 0xFF)]
    }
    
} // end DeskPeripheralWrapper












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
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.iMovr.centralQueueName", attributes: .concurrent)
        
        // Creates Manager to scan for, connect to, and manage/collect data from peripherals (desks)
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
        
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
