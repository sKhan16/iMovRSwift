//
//  CoreDataManager.swift
//  iMovR
//
//  Created by Michael Humphrey on 11/24/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import CoreBluetooth

public class DeviceDataManager: ObservableObject {
    @EnvironmentObject var BTManager: DeviceBluetoothManager
    
    @Published var savedDevices: [Desk] = []
    
    private var fetchedDevices: [ZipDeskData]?
    
    // Access context for CoreData persistent storage
    @Environment(\.managedObjectContext) var managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
//    init(savedDevicesBinding: Binding<[Desk]>) {
//        self.savedDevices = savedDevicesBinding
    init() {
        guard self.pullPersistentData() else {
            print("error retrieving stored desks and presets")
            return
        }
        print("ZipDeskData successfully retrieved")
    }
    
    
    func pullPersistentData () -> Bool {
        var convertedDevices: [Desk] = []
        do {
            self.fetchedDevices = try context.fetch(ZipDeskData.fetchRequest())
        } catch {
            print("Failed to fetch ZipDeskData")
            return false
        }
        guard (self.fetchedDevices != nil) else {
            print("error fetching ZipDeskData")
            return false
        }
        
        // iterate: convertedDevices(new) + savedDevices(old) -> savedDevices(current)
        if !self.fetchedDevices!.isEmpty {
            for deviceData in self.fetchedDevices! {
                convertedDevices.append (
                    Desk(name: deviceData.name,
                         deskID: Int(deviceData.deskID),
                         presetHeights: self.dearchiveFloatArray(data: deviceData.presetHeights),
                         presetNames: self.dearchiveStringArray(data: deviceData.presetNames)) )
                print("Found Saved ZipDeskData(\(deviceData.name) - id: \(deviceData.deskID)")
            }
        }
        print("##warning##-- (attempted fix)-- \nDeviceDataManager.pullPersistentData(): overwriting local saved devices-\n-may lose peripheral references if left unchecked")
        // must copy the in-range peripherals or they would be discarded
        for device in self.savedDevices {
            if(device.peripheral != nil) {
                if let index: Int = convertedDevices.firstIndex (
                        where: { (nextDevice: Desk) -> Bool in
                            nextDevice.id == device.id
                        }) {
                    // store CBPeripheral in new reference to device
                    convertedDevices[index].peripheral = device.peripheral
                }
            }
        }
        self.savedDevices = convertedDevices
        return true
    } // end pullPersistentData()
    
    
    func findDeskData (desk: Desk) -> ZipDeskData? {
        print("DeviceDataManager.findDeskData---testing new matching ZipDeskData search")
        guard let index: Int = self.fetchedDevices!.firstIndex(
                where: { (thisDeskData: ZipDeskData) -> Bool in
                    thisDeskData.deskID == desk.id
                }) else {
            return nil
        }
        return fetchedDevices![index]
    }
    
    
    // Add/Save a newly Discovered Device to Persistent Saved Devices
    func addDevice(desk: Desk) -> Bool {
        if let _: Int = self.fetchedDevices!.firstIndex(
                where: { (thisDeskData: ZipDeskData) -> Bool in
                    thisDeskData.deskID == desk.id
                }) {
            print("error: that Device is already stored on this phone")
            return false
        }
        
        let newDeskData = ZipDeskData(context: self.context)
        newDeskData.name = desk.name
        newDeskData.deskID = Int64(desk.id)
        newDeskData.isLastConnectedTo = true // Initialize to true when auto connecting on save of new device
//MARK: Convert presets to NSData before storing in ZipDeskData properties
        
        newDeskData.presetHeights = self.archiveFloatArray(array: desk.presetHeights)
        newDeskData.presetNames = self.archiveStringArray(array: desk.presetNames)
        
        // Turn off autoconnect on all other desk devices
        // Later this can be a user adjusted feature, if we prioritize by most recently connected device
        for otherDeskData in self.fetchedDevices! {
            if(otherDeskData.deskID != newDeskData.deskID) {
                otherDeskData.isLastConnectedTo = false
            }
        }
        
        var isSuccess: Bool
        do {
            try self.context.save()
            isSuccess = true
            print("Desk saved.")
        } catch {
            isSuccess = false
            print("DeviceDataManager.addDesk CoreData save error:\n---------------\n"+error.localizedDescription+"/n")
        }
        if isSuccess {
            if !self.pullPersistentData() {
                isSuccess = false
                print("DeviceDataManager.addDesk data fetch error")
            }
        }
        return isSuccess
    }
    
    
    func removeDevice (desk: Desk) {
        guard let deskData: ZipDeskData = findDeskData(desk: desk) else {
            print("DeviceDataManager.removeDesk error: desk data not found")
            return
        }
        self.context.delete(deskData)
        do {
            try self.context.save()
            print("desk deletion saved")
        } catch {
            print(error.localizedDescription)
            print("DeviceDataManager.removeDesk error saving desk removal")
        }
        if !self.pullPersistentData() {
            print("DeviceDataManager.removeDesk data fetch error")
        }
    }
    
    
    func editDevice (desk: Desk) {
        guard let deskData: ZipDeskData = findDeskData(desk: desk) else {
            print("DeviceDataManager.editDesk error: desk data not found")
            return
        }
//        if ## desk.id == zipdesk.getDesk().id ## {
//            deskData.isLastConnectedTo = true // Initialize to true when auto connecting on save of new device
//            self.updateBTManagerConnectedDesk(connectedDesk: <#T##Desk#>)
//        }
        deskData.name = desk.name
        deskData.deskID = Int64(desk.id)
        
        deskData.presetHeights = self.archiveFloatArray(array: desk.presetHeights)
        deskData.presetNames = self.archiveStringArray(array: desk.presetNames)
        do {
            try self.context.save()
            print("Desk edit saved.")
        } catch {
            print(error.localizedDescription)
            print("DeviceDataManager.editDesk error saving edited desk")
        }
        if !self.pullPersistentData() {
            print("DeviceDataManager.editDesk error pulling saved desks")
        }
    }
    
    // Called after currently connected device is edited
    private func updateBTManagerConnectedDesk(connectedDesk: Desk) {
        guard connectedDesk.peripheral?.state == .connected else {
            print("DeviceDataManager: error - \"connectedDesk\" peripheral not connected")
            return
        }
        if BTManager.zipdesk.setDesk(desk: connectedDesk) {
            print("DeviceDataManager: successfully updated current desk")
        }
    }
    
    
    private func archiveStringArray(array: [String]) -> Data {
        do {                                // this might be the wrong archive fx
            let data = try NSKeyedArchiver.archivedData(withRootObject: array/*Array<String>.self---NSArray.self*/, requiringSecureCoding: false)
            return data
        } catch {
            fatalError("Can't encode Array<String> for CoreData:\n\(error)")
        }
    }
    
    private func dearchiveStringArray(data: Data) -> [String] {
        do {                                        // this might be the wrong unarchive fx
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] else {
                fatalError("DeviceDataManager.dearchiveStringArray(data) - Can't get Array<String>")
            }
            return array
        } catch {
            fatalError("DeviceDataManager.dearchiveStringArray(data) - Can't encode data: \(error)")
        }
    }
    
    
    private func archiveFloatArray(array: [Float]) -> Data {
        do {                                // this might be the wrong archive fx
            let data = try NSKeyedArchiver.archivedData(withRootObject: array/*NSArray.self*/, requiringSecureCoding: false)
            return data
        } catch {
            fatalError("Can't encode Array<Float> for CoreData:\n\(error)")
        }
    }
    
    private func dearchiveFloatArray(data: Data) -> [Float] {
        do {                                        // this might be the wrong unarchive fx
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Float] else {
                fatalError("DeviceDataManager.dearchiveFloatArray(data) - Can't get Array<Float>")
            }
            return array
        } catch {
            fatalError("DeviceDataManager.dearchiveFloatArray(data) - Can't encode data: \(error)")
        }
    }
    
}
