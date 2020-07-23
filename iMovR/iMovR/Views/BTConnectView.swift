//
//  BTConnectView.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct BTConnectView: View {
    
    @EnvironmentObject var user: UserObservable
    
    @Binding var showBTConnect: Bool
    
    var body: some View {
        // Try cocoapod popoverview later
        NavigationView {
            VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            
        }
    }
    .navigationBarTitle("Connect to Desk")
    }
}


// get popover to work
//popover(item: <#T##Binding<Identifiable?>#>, content: self)

struct BTConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BTConnectView(showBTConnect: .constant(true))
            .environmentObject(UserObservable())
    }
}
