//
//  UserDataManager.swift
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
    @Published var agreedToZipDeskWaiver: Bool = false
    @Published var tngEnabled: Bool = false
    //@Published var agreedToTreadmillWaiver: Bool = false
    
    private var fetchedUserData: [UserData]?
    
    enum LoginState {
        case firstTime
        case Connected
        case Disconnected
        
    }
    
    init() {
        guard self.pullPersistentData() else {
            print("UserDataManager -- ERROR: failed when retrieving user states")
            return
        }
    }
    
    
    func pullPersistentData() -> Bool {
        do {
            self.fetchedUserData = try context.fetch(UserData.fetchRequest())
        } catch {
            print("failed to fetch UserData")
            return false
        }
        guard (self.fetchedUserData != nil) else {
            print("no UserData found - nil")
            return false
        }
        
        if !(self.fetchedUserData!.isEmpty) {
            print("Found Saved UserData")
            
            let userData: UserData = self.fetchedUserData![0]
            
            self.agreedToZipDeskWaiver = userData.touchAndGoWaiver
            self.tngEnabled = userData.touchAndGoEnabled
            //self.agreedToTreadmillWaiver = userData.treadmillWaiver
        }
        return true
    }
    
    
    func setTNGWaiver(_ value: Bool) -> Bool {
        if self.fetchedUserData != nil, !self.fetchedUserData!.isEmpty {
            self.fetchedUserData![0].touchAndGoWaiver = value
            self.fetchedUserData![0].touchAndGoEnabled = self.tngEnabled
        } else {
            print("no UserData found, initializing")
            let newUserData = UserData(context: self.context)
            newUserData.touchAndGoWaiver = value
        }
        return self.saveUserData()
    }
    
    func toggleTNG(_ value: Bool) -> Bool {
        print("turning TnG " + (value ? "on" : "off"))
        if self.fetchedUserData != nil, !self.fetchedUserData!.isEmpty {
            self.fetchedUserData![0].touchAndGoEnabled = value
            self.fetchedUserData![0].touchAndGoWaiver = self.agreedToZipDeskWaiver
        } else {
            print("no UserData found, initializing")
            let newUserData = UserData(context: self.context)
            newUserData.touchAndGoEnabled = value
        }
        return self.saveUserData()
    }
    
    
    func saveUserData() -> Bool {
        var isSuccess: Bool
        do {
            try self.context.save()
            isSuccess = true
            print("UserData saved.")
        } catch {
            isSuccess = false
            print("UserDataManager.saveUserData error: \n" + error.localizedDescription)
        }
        if isSuccess {
            if !self.pullPersistentData() {
                isSuccess = false
                print("UserDataManager.saveUserData data fetch error")
            }
        }
        return isSuccess
    }

}
