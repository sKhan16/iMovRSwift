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

public class DeviceDataManager: ObservableObject {
    //@Binding var savedDevices: Binding<[Desk]>
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
        
        if !self.fetchedDevices!.isEmpty {
            for zipdeskData in self.fetchedDevices! {
                convertedDevices.append(Desk(zipdeskData: zipdeskData))
                print("DeskData(\(zipdeskData.name)'s deskID = \(zipdeskData.deskID)")
            }
        }
        
        self.savedDevices = convertedDevices
        print("##warning##-- DeviceDataManager.pullPersistentData(): overwriting local saved devices-\n-may lose peripheral references if left unchecked")
        return true
    }
    
    
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
//
//         for deskData in self.fetchedDesks! {
//
//         //print("~~~")
//         //print("deskData deskId: \(deskData.deskID)\n desk deskId: \(desk.id)\n~~~")
//         if deskData.deskID == desk.id {
//
//         print("Found deskData!")
//         return deskData
//         }
//         }
//         return nil
//    }
    
    
    // Add/Save a newly Discovered Device to Persistent Saved Devices
    func addDesk(desk: Desk) -> Bool {
        if let index: Int = self.fetchedDevices!.firstIndex(
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
        newDeskData.presetHeights = desk.presetHeights
        newDeskData.presetNames = desk.presetNames
        
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
    
    
    func removeDesk (desk: Desk) {
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
    
    
    func editDesk (desk: Desk) {
        guard let deskData: ZipDeskData = findDeskData(desk: desk) else {
            print("DeviceDataManager.editDesk error: desk data not found")
            return
        }
        deskData.name = desk.name
        deskData.deskID = Int64(desk.id)
        deskData.isLastConnectedTo = true // Initialize to true when auto connecting on save of new device
        deskData.presetHeights = desk.presetHeights
        deskData.presetNames = desk.presetNames
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
    
    
}
