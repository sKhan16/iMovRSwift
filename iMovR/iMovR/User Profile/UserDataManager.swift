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
import CoreData

public class UserDataManager: ObservableObject {
    
    // Access CoreData persistent storage for desks and presets
    @Environment(\.managedObjectContext) var managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    @Published var loginState: LoginState = .firstTime
    
    enum LoginState {
        case firstTime
        case Connected
        case Disconnected
        
    }
    
    init() {
        guard self.pullPersistentData() else {
            print("error retrieving user states")
            return
        }
        print("user profile successfully retrieved")
    }
    
    
    func pullPersistentData() -> Bool {
        return false // needs user state implementation
    }
    
    /// Shakeel, I deleted the code here in old UserObservable (now UserDataManager) to clear up about 30 compile errors.
    /// When we implement user account data I'll help you get it set up. Most of the old code is in DeviceDataManager now.
    /// Some of the old old commented out code (if even needed) will have to be grabbed from an old git commit.
    /// No problem though.


