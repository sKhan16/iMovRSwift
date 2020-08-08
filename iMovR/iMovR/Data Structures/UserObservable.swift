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
    
    @Published var presets : [Preset] = []
    @Published var loginState: LoginState = .firstTime
    
    @Published var desks: [Desk] = []
    @Published var currDeskID: Int = 0
    @Published var currDeskName: String = "Please add or select a desk."

    
    init() {
        // Populate desks and presets from CoreData on startup
        self.pullPersistentData()
    }
    
    
    func addPreset (name: String, height: Float) {
        let newPreset = Preset(name: name, height: height)
        
        guard !presets.contains(where: { $0 as AnyObject === newPreset as AnyObject }) else {
            print("error: that preset is already stored on the device")
            return
        }
        presets.append(newPreset)
        
        let newPresetData = PresetData(context: managedObjectContext)
        newPresetData.name = name
        newPresetData.height = height
        newPresetData.uuid = newPreset.id
        /*
         Save the preset to CoreData here
         */
        
    }
    
    func removePreset (preset: Preset) {
        presets.removeAll(where: { $0 as AnyObject === preset as AnyObject })
        /*
         Remove the preset from CoreData here
         */
    }
    
    func editPreset (index: Int, name: String, height: Float) {
        presets[index].name = name
        presets[index].height = height
        /*
         Edit the preset from CoreData here
         */
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

    func pullPersistentData() {
        /*
         Perform startup desk and preset data pulls from CoreData
         */
    }

//    func addTestPresets() {
//        for index in (0...10) {
//            self.addPreset(name: "test", height: Float(index))
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
