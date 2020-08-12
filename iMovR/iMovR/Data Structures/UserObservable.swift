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
    
//    @FetchRequest(entity: PresetData.entity(),
//                  sortDescriptors: []//,
//                )
//    var fetchedPresets: FetchedResults<PresetData>
    
    var fetchedPresets: [PresetData]?
    var fetchedDesks: [DeskData]?
    /*
     Need to update presets array with these results every time it changes
        -by using a forEach loop
     */
    
//    @FetchRequest(entity: DeskData.entity(),
//                  sortDescriptors: []//,
//        //predicate: NSPredicate(format: "isLastConnectedTo")
//    )
//    var fetchedDesks: FetchedResults<DeskData>
    
    @Published var presets : [Preset] = []
    @Published var loginState: LoginState = .firstTime
    
    @Published var desks: [Desk] = []
    @Published var currDeskID: Int = 0
    @Published var currDeskName: String = "Please add or select a desk."

    
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
        
        //self.fetchedPresets = FetchRequest<PresetData>(entity: PresetData.entity(), sortDescriptors: [], predicate: NSPredicate(format: "deskID == %@", self.currDeskID))
        
        //self.fetchedDesks = FetchRequest<DeskData>(entity: DeskData.entity(), sortDescriptors: [])
        
        var fPresets: [Preset] = []
        var fDesks: [Desk] = []
        
        do {
            self.fetchedPresets = try context.fetch(PresetData.fetchRequest())
        } catch {
            
        }
        
        
        if !self.fetchedPresets!.isEmpty {
            for presetData in self.fetchedPresets!  {
            fPresets.append(Preset(name: presetData.name, height: presetData.height, deskID: Int(presetData.deskID)))
        }
    }
        /// Uncomment when using tag method of fetching
//        for presetData in fetchedPresets {
//            fPresets.append(Preset(name: presetData.name, height: presetData.height, deskID: Int(presetData.deskID)))
//        }
//        for deskData in fetchedDesks {
//            fDesks.append(Desk(name: deskData.name, deskID: Int(deskData.deskID)))
//        }
        
        self.presets = fPresets
        self.desks = fDesks
        
        /*
         Perform startup desk and preset data pulls from CoreData
         if fails, return false
         
         desks = ...
         presets = ...
         */
        return true
    }
    
    
    func setCurrentDesk(desk: Desk) -> Bool {
        /*
         In CoreData guard that a desk matches this desk, else
         return false
         */
        self.currDeskID = desk.id
        self.currDeskName = desk.name
        return true
    }
    
    func addPreset (name: String, height: Float) -> Bool {
        let newPreset = Preset(name: name, height: height, deskID: self.currDeskID)

        guard !self.presets.contains(where: { $0 as AnyObject === newPreset as AnyObject }) else {
            print("error: that preset is already stored on the device")
            return false
        }
        // Add the preset to the local presets
        self.presets.append(newPreset)
        
        // Create a persistent CoreData representation of the new preset
        let newPresetData = PresetData(context: self.context)
            newPresetData.name = name
            newPresetData.height = height
            newPresetData.uuid = newPreset.id
            newPresetData.deskID = Int64(self.currDeskID)
        
        // Try saving the preset to CoreData
        do {
            try self.context.save()
            print("Order saved.")
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
        
    } // addPreset end
    
    func removePreset (preset: Preset) {
        self.presets.removeAll(where: { $0 as AnyObject === preset as AnyObject })
        /*
         Remove the preset from CoreData here
         */
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
            /*
             Edit the preset from CoreData here if isChanged is true
             */
        }
    }
    
    
    func addDesk (name: String, deskID: Int) {
        let newDesk = Desk(name: name, deskID: deskID)
        
        guard !desks.contains(where: { $0 as AnyObject === newDesk as AnyObject }) else {
            print("error: that desk is already stored on the device")
            return
        }
        desks.append(newDesk)
        
        let newDeskData = DeskData(context: managedObjectContext)
        newDeskData.name = name
        newDeskData.deskID = Int64(deskID)
        newDeskData.isLastConnectedTo = false // Maybe initialize to true?
                                        // Must check if desk is connected
        /*
         Save the desk to CoreData here
         */
    }
    
    func removeDesk (desk: Desk) {
        desks.removeAll(where: { $0 as AnyObject === desk as AnyObject })
        /*
         Remove the desk from CoreData here
         */
    }
    
    func modifyDeskName (index: Int, name: String) {
        guard index < desks.count else {
            print("editDesk(...) - index out of bounds error")
            return
        }
        desks[index].name = name
        
        /*
         Edit the desk in CoreData
         */

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
