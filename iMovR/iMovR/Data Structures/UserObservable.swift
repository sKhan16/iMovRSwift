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
    @Published var presets: [(name: String, height: Float)] = []
    @Published var loginState: LoginState = .firstTime
    
    @Published var currDeskID: Int = 0
    @Published var currDeskName: String = "--deskName_not_assigned--"
    @Published var desks: [(name: String, deskID: Int)] = []
    
    init() {
        self.addTestPresets()
        
    }
    
    func addPreset (name: String, height: Float) {
        presets.append((name, height))
    }
    
    func addDesk (name: String, deskID: Int) {
        desks.append((name, deskID))
    }
    
    func removeDesk (name: String, deskID: Int) {
        desks.removeAll(where: { $0 == (name, deskID) })
    }
    func saveCurrentDesk () {
        if !desks.contains(where: { $0 == (self.currDeskName, self.currDeskID)} ) {
            addDesk(name: self.currDeskName, deskID: self.currDeskID)
        }
    }
    

    func addTestPresets() {
        for index in (0...10) { 
            self.addPreset(name: "test \(index)", height: Float(index))
        }
    }

    
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
