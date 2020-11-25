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
    var savedDevices: [Desk]?
    private var fetchedDevices: [ZipDeskData]?
    
    // Access CoreData persistent storage for desks
    @Environment(\.managedObjectContext) var managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    init() {
        guard self.pullPersistentData() else {
            print("error retrieving stored desks and presets")
            return
        }
        print("ZipDeskData successfully retrieved")
    }
    
    
    func pullPersistentData () -> Bool {
        var devices: [Desk] = []
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
                self.savedDevices.append(Desk(name: zipdeskData.name, deskID: Int(deskData.deskID)), )
                print("DeskData(\(deskData.name)'s deskID = \(deskData.deskID)")
            }
        }
        
        self.savedDevices = fDesks
        return true
    }
    
    
    func findDeskData (desk: Desk) -> ZipDeskData? {
        guard let index: Int = self.fetchedDevices!.firstIndex(
                where: { (fetchedDeskData) -> Bool in
                    fetchedDeskData.id == desk.id
                }) else {
            return nil
        }
        return fetchedDevices![index]
        /*
         for deskData in self.fetchedDesks! {
         
         //            print("~~~")
         //            print("deskData deskId: \(deskData.deskID)\n desk deskId: \(desk.id)\n~~~")
         if deskData.deskID == desk.id {
         
         print("Found deskData!")
         return deskData
         }
         }
         return nil
         */
    }
    
    
    func addDesk() -> Bool {
        var isSuccess: Bool = false
        
        guard !desks.contains(where: { $0 as AnyObject === self.currentDesk as AnyObject }) else {
            print("error: that desk is already stored on the device")
            return false
        }
        desks.append(self.currentDesk)
        
        let newDeskData = DeskData(context: self.context)
        newDeskData.name = self.currentDesk.name
        newDeskData.deskID = Int64(self.currentDesk.id)
        newDeskData.isLastConnectedTo = true // Maybe initialize to true?
        
        // Set all other desks besides currentDesk to not last connected
        for deskData in self.fetchedDesks! {
            if(deskData.deskID != self.currentDesk.id) {
                deskData.isLastConnectedTo = false
            }
        }
        
        do {
            try self.context.save()
            print("Desk saved.")
            isSuccess = true
        } catch {
            print(error.localizedDescription)
        }
        if isSuccess {
            if !self.pullDeskData() {
                print("addDesk(..) data fetch error")
            }
        }
        
        return isSuccess
    }
    
    
    func removeDesk (index: Int) {
        let desk: Desk = self.desks[index]
        
        guard let deskData: DeskData = findDeskData(desk: desk) else {
            print("Error removing deskData")
            return
        }
        
        self.context.delete(deskData)
        self.desks.remove(at: index)
        /*
         Remove the preset from CoreData here
         */
        do {
            try self.context.save()
            print("Desk deletion saved.")
            
        } catch {
            print(error.localizedDescription)
            print("Error saving removed preset")
        }
        
        if !self.pullDeskData() {
            print("removeDesk(..) data fetch error")
        }
    }
    
    
    func editDesk (index: Int, name: String = "", deskID: Int = 0) {
        var isChanged: Bool = false
        
        if (name != "") {
            self.desks[index].name = name
            isChanged = true
        }
        if (deskID > 0) {
            self.desks[index].id = deskID
            isChanged = true
        }
        
        if (isChanged) {
            let desk: Desk = self.desks[index]
            
            guard let deskData: DeskData = findDeskData(desk: desk) else {
                print("Error retrieving deskData to edit")
                return
            }
            
            deskData.name = desk.name
            deskData.deskID = Int64(desk.id)
            
            do {
                try self.context.save()
                print("Desk edit saved.")
                
            } catch {
                print(error.localizedDescription)
                print("Error saving edited desk")
            }
            
            if !self.pullDeskData() {
                print("error pulling saved desks in editDesk(..)")
            }
        }
    }
    
    

    
    
    
//
//    func addPreset (name: String, height: Float, index: Int) -> Bool {
//        var isSuccess: Bool = false
//
//        //To test new UI design for presets
//        print("self.user.addPreset(...) index: \(index)")
//        self.testPresets.insert(height, at: index)
//        self.testPresets.remove(at: index + 1)
//
//        self.testPresetNames.insert(name, at: index)
//        self.testPresetNames.remove(at: index + 1)
//
//        let newPreset = Preset(name: name, height: height, deskID: self.currentDesk.id)
//
//        // Add the preset to the local presets
//        self.presets.append(newPreset)
//
//        // Create a persistent CoreData representation of the new preset
//        let newPresetData = PresetData(context: self.context)
//        newPresetData.name = name
//        newPresetData.height = height
//        newPresetData.uuid = newPreset.id
//        newPresetData.deskID = Int64(self.currentDesk.id)
//
//        // Try saving the preset to CoreData
//        do {
//            try self.context.save()
//            print("Preset saved.")
//            isSuccess = true
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        //fetch new data
//        if isSuccess {
//            if !self.pullPresetData() {
//                print("addPreset(..) data fetch error")
//            }
//        }
//
//        return isSuccess
//
//    } // addPreset end
//
//    func removePreset (index: Int) {
//        let preset: Preset = self.presets[index]
//
//
//
//        guard let presetData: PresetData = findPresetData(preset: preset) else {
//            print("Error removing preset")
//            return
//        }
//
//        self.context.delete(presetData)
//        self.presets.remove(at: index)
//        /*
//         Remove the preset from CoreData here
//         */
//        do {
//            try self.context.save()
//            print("Preset saved.")
//
//        } catch {
//            print(error.localizedDescription)
//            print("Error saving removed preset")
//        }
//
//        if !self.pullPresetData() {
//            print("removePreset(..) data fetch error")
//        }
//
//    }
//
    
//    //Finds and returns PresetData that matches the given preset
//    // Otherwise, returns nil
    
//    func findPresetData (preset: Preset) -> PresetData? {
//
//        //var presetDataTmp: PresetData
//
//        for presetData in self.fetchedPresets! {
//
//            //            print("~~~")
//            //            print("presetData uuid: \(presetData.uuid)\n preset uuid: \(preset.id)\n~~~")
//            if presetData.uuid == preset.id {
//
//                print("Found preset!")
//                return presetData
//            }
//        }
//
//        return nil
//    }
//
//    func editPreset (index: Int, name: String = "", height: Float = 0.0) {
//
//        var isChanged: Bool = false
//
//        if (name != "") {
//            self.testPresetNames.insert(name, at: index)
//            self.testPresetNames.remove(at: index + 1)
//            isChanged = true
//        }
//        if (height != 0.0) {
//            self.testPresets.insert(height, at: index)
//            self.testPresets.remove(at: index + 1)
//            isChanged = true
//        }
//
//    }
//
    
    
    
    
    
    /// OLD core data implementation for presets
    //    func editPreset (index: Int, name: String = "", height: Float = 0.0) {
    //
    //        var isChanged: Bool = false
    //
    //        if (name != "") {
    //            self.presets[index].name = name
    //            isChanged = true
    //        }
    //        if (height != 0.0) {
    //            self.presets[index].height = height
    //            isChanged = true
    //        }
    //
    //        if (isChanged) {
    //            let preset: Preset = self.presets[index]
    //
    //            /*
    //             Edit the preset from CoreData here if isChanged is true
    //             */
    //            guard let presetData: PresetData = findPresetData(preset: preset) else {
    //                print("Error retrieving presetData to edit")
    //                return
    //            }
    //
    //            presetData.name = preset.name
    //            presetData.height = preset.height
    //
    //            do {
    //                try self.context.save()
    //                print("Preset edit saved.")
    //
    //            } catch {
    //                print(error.localizedDescription)
    //                print("Error saving edited preset")
    //            }
    //
    //            if !self.pullPresetData() {
    //                print("editPreset(..) data fetch error")
    //            }
    //        }
    //    }
    
    
    
//    func addTestPresets() {
//        for index in (0...10) {
//            self.addPreset(name: "test", height: Float(index))
//        }
//    }

//    func addTestDesks() {
//        for i in (0...9) {
//            self.addDesk(name: "Desk \(i)", deskID: (10000000 + i))
//        }
//    }
    
}




enum LoginState {
    case firstTime
    case Connected
    case Disconnected
    
}



import Foundation
