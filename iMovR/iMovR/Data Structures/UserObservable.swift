//
//  UserObservable.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class UserObservable: ObservableObject {
    
    // Access CoreData persistent storage for desks and presets
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetches persistent presets automatically
    //- just use fetchedPresets
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedPresets: [PresetData]?
    var fetchedDesks: [DeskData]?
    
    @Published var presets : [Preset] = []
    @Published var desks: [Desk] = []

    @Published var currentDesk: Desk = Desk(name: "Please add or select a desk.", deskID: 0)
    
    @Published var loginState: LoginState = .firstTime
    
    init() {
        
        
        //self.fetchedPresets = FetchRequest<PresetData>(entity: PresetData.entity(), sortDescriptors: [], predicate: NSPredicate(format: "deskID == %@", 0))
        
        //self.fetchedDesks = FetchRequest<DeskData>(entity: DeskData.entity(), sortDescriptors: [])
        
        // Populate desks and presets from CoreData on startup
        guard self.pullPersistentData() else {
            print("error retrieving stored desks and presets")
            return
        }
        
        
        print("presets and desks successfully retrieved")
    }
    
    func pullPersistentData() -> Bool {
        return self.pullPresetData() && self.pullDeskData()
        //        var fPresets: [Preset] = []
        //        var fDesks: [Desk] = []
        //
        //        do {
        //            self.fetchedPresets = try context.fetch(PresetData.fetchRequest())
        //        } catch {
        //
        //        }
        //
        //        do {
        //            self.fetchedDesks = try context.fetch(DeskData.fetchRequest())
        //        } catch {
        //
        //        }
        //
        //        guard (self.fetchedPresets != nil || self.fetchedDesks != nil) else {
        //            print("error fetching data")
        //            return false
        //        }
        //
        //        if !self.fetchedPresets!.isEmpty {
        //            for presetData in self.fetchedPresets!  {
        //
        //            var preset: Preset = Preset(name: presetData.name, height: presetData.height, deskID: Int(presetData.deskID))
        //
        //            preset.setId(id: presetData.uuid)
        //
        //            fPresets.append(preset)
        //        }
        //    }
        //        if !self.fetchedDesks!.isEmpty {
        //            for deskData in self.fetchedDesks! {
        //                fDesks.append(Desk(name: deskData.name, deskID: Int(deskData.deskID)))
        //            }
        //        }
        //
        //
        //        self.presets = fPresets
        //        self.desks = fDesks
        //
        //
        //        return true
    }
    
    func pullPresetData () -> Bool {
        var fPresets: [Preset] = []
        
        do {
            self.fetchedPresets = try context.fetch(PresetData.fetchRequest())
        } catch {
            print("Failed to fetch PresetData")
            return false
        }
        guard (self.fetchedPresets != nil) else {
            print("error fetching PresetData")
            return false
        }
        
        if !self.fetchedPresets!.isEmpty {
            for presetData in self.fetchedPresets!  {
                var preset: Preset = Preset(name: presetData.name, height: presetData.height, deskID: Int(presetData.deskID))
                
                preset.setId(id: presetData.uuid)
                
                fPresets.append(preset)
            }
        }
        
        self.presets = fPresets
        return true
    }
    
    func pullDeskData () -> Bool {
        var fDesks: [Desk] = []
        do {
            self.fetchedDesks = try context.fetch(DeskData.fetchRequest())
        } catch {
            print("Failed to fetch DeskData")
            return false
        }
        guard (self.fetchedDesks != nil) else {
            print("error fetching DeskData")
            return false
        }
        
        if !self.fetchedDesks!.isEmpty {
            for deskData in self.fetchedDesks! {
                fDesks.append(Desk(name: deskData.name, deskID: Int(deskData.deskID)))
            }
        }
        
        self.desks = fDesks
        return true
    }
    
    
    func addPreset (name: String, height: Float) -> Bool {
        var isSuccess: Bool = false
        
        let newPreset = Preset(name: name, height: height, deskID: self.currentDesk.id)
        
        // Add the preset to the local presets
        self.presets.append(newPreset)
        
        // Create a persistent CoreData representation of the new preset
        let newPresetData = PresetData(context: self.context)
        newPresetData.name = name
        newPresetData.height = height
        newPresetData.uuid = newPreset.id
        newPresetData.deskID = Int64(self.currentDesk.id)
        
        // Try saving the preset to CoreData
        do {
            try self.context.save()
            print("Preset saved.")
            isSuccess = true
        } catch {
            print(error.localizedDescription)
        }
        
        //fetch new data
        if isSuccess {
            self.pullPresetData()
        }
        
        return isSuccess
        
    } // addPreset end
    
    func removePreset (index: Int) {
        let preset: Preset = self.presets[index]
        
        
        
        guard let presetData: PresetData = findPresetData(preset: preset) else {
            print("Error removing preset")
            return
        }
        
        self.context.delete(presetData)
        self.presets.remove(at: index)
        /*
         Remove the preset from CoreData here
         */
        do {
            try self.context.save()
            print("Preset saved.")
            
        } catch {
            print(error.localizedDescription)
            print("Error saving removed preset")
        }
        
        self.pullPresetData()
        
    }
    
    //Finds and returns PresetData that matches the given preset
    // Otherwise, returns nil
    func findPresetData (preset: Preset) -> PresetData? {
        
        //var presetDataTmp: PresetData
        
        for presetData in self.fetchedPresets! {
            
            //            print("~~~")
            //            print("presetData uuid: \(presetData.uuid)\n preset uuid: \(preset.id)\n~~~")
            if presetData.uuid == preset.id {
                
                print("Found preset!")
                return presetData
            }
        }
        
        return nil
    }
    
    func editPreset (index: Int, name: String = "", height: Float = 0.0) {
        
        var isChanged: Bool = false
        
        if (name != "") {
            self.presets[index].name = name
            isChanged = true
        }
        if (height != 0.0) {
            self.presets[index].height = height
            isChanged = true
        }
        
        if (isChanged) {
            let preset: Preset = self.presets[index]
            
            /*
             Edit the preset from CoreData here if isChanged is true
             */
            guard let presetData: PresetData = findPresetData(preset: preset) else {
                print("Error retrieving presetData to edit")
                return
            }
            
            presetData.name = preset.name
            presetData.height = preset.height
            
            do {
                try self.context.save()
                print("Preset edit saved.")
                
            } catch {
                print(error.localizedDescription)
                print("Error saving edited preset")
            }
            
            self.pullPresetData()
        }
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
            self.pullDeskData()
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
        self.presets.remove(at: index)
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
        
        self.pullDeskData()
    }
    
    func modifyDeskName (index: Int, name: String) {
        guard index < desks.count else {
            print("modifyDeskName(..) - index out of bounds error")
            return
        }
        
        if (name != "") {
            self.desks[index].name = name
            let desk: Desk = self.desks[index]
            
            /*
             Edit the preset from CoreData here if isChanged is true
             */
            guard let deskData: DeskData = findDeskData(desk: desk) else {
                print("Error retrieving deskData to edit")
                return
            }
            
            deskData.name = desk.name
            
            do {
                try self.context.save()
                print("Desk edit saved.")
                
            } catch {
                print(error.localizedDescription)
                print("Error saving edited desk")
            }
            
            self.pullDeskData()
        }
    }
    
    func findDeskData (desk: Desk) -> DeskData? {
        for deskData in self.fetchedDesks! {
            
            //            print("~~~")
            //            print("deskData deskId: \(deskData.deskID)\n desk deskId: \(desk.id)\n~~~")
            if deskData.deskID == desk.id {
                
                print("Found deskData!")
                return deskData
            }
        }
        
        return nil
    }
    
    
    
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



struct UserObservable_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
