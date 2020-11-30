//
//  BTConnectView.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct BTConnectView: View {

    
    // For saving to CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @State private var inputDeskName: String = ""
    @State private var inputDeskID: String = ""
    @Binding var showBTConnect: Bool
    @State var notifyWrongInput: Bool = false
    
    
    var body: some View {
        // Try cocoapod popoverview later
        NavigationView {
            
            VStack {
                Form {
                    Button(action: {
                        self.bt.scanForDevices()
                        
                    }) {
                        Text("Scan for Desks")
                    }
                    Spacer()
                    List {
                        //AddDeskView()
                        //Text("Add desks here")
                        Text("Discovered Devices:")
                        if bt.discoveredDevices.count > 0 {
                            ForEach(bt.discoveredDevices.indices, id: \.self) { index in
                                Button(action: {
                                    self.bt.connectToDevice(device: self.bt.discoveredDevices[index])
                                    
                                }) {
                                    Text("Device #" + String(self.bt.discoveredDevices[index].id))
                                }
                                    /*
                                     DeskSettingDetail(currIndex: index) ) {
                                     SettingRow(name: self.bt.discoveredDevices[index].name, id:
                                     String(self.bt.discoveredDevices[index].id))
                                     }
                                     */
                            }
                        }
                    }
                    
                    // Desk name input section of form
                    Section(header:
                        Text("Name Your Desk:")
                            .font(.headline)
                    ) {
                        TextField("Desk Name", text: $inputDeskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    } //end 'Name' section
                    
                    // Desk ID input section of form
                    Section(header:
                        Text("Input Desk ID:")
                            .font(.headline)
                    ) {
                        TextField("Desk ID", text: $inputDeskID)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    } //end 'Desk ID' section
                    
                    Section(header: Text("Instructions:")
                        .font(.headline)
                    ) {
                        VStack() {
                            if (notifyWrongInput) {
                                VStack {
                                    Text("Invalid field entries.")
                                        .foregroundColor(.red)
                                        .padding()
                                    //Spacer()
                                }
                            }
                            Text("Please give your desk a name and input the 8 digit manufacturer ID.\n\nThe manufacturer ID is found underneath the desk. There is a small box with a plug on each end, with a QR sticker. The 8 digit number is printed on this sticker.")
                                .foregroundColor(.primary)
                                .font(.callout)
                                .padding()
                        } //end VStack
                    } //end notification section
                    
                } //end form
                
            }
            .navigationBarTitle("Add New Desk", displayMode: .inline)
            .navigationBarItems(
                leading: CloseButton(
                    showSheet: self.$showBTConnect
                ),
                trailing: BTDoneButton(
                    inputDeskName: self.$inputDeskName,
                    inputDeskID: self.$inputDeskID,
                    showBTConnect: self.$showBTConnect,
                    notifyWrongInput: self.$notifyWrongInput
                )
            )

        }
    } //end body
    
}


// Bluetooth connection starts in BTDoneButton
struct BTDoneButton: View {
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var inputDeskName: String
    @Binding var inputDeskID: String
    @Binding var showBTConnect: Bool
    @Binding var notifyWrongInput: Bool
    
    
    var body: some View {
        Button(action: {
            let deskID: Int = Int(self.inputDeskID) ?? 0
            
            if (self.inputDeskName != "") && (self.inputDeskID.count == 8) {
                print("correct desk info submitted")
                //Try to store user input, connect and exit connect view
                let currDesk = Desk(name: self.inputDeskName, deskID: deskID, presetHeights:[], presetNames: [])
                self.user.currentDesk = currDesk
                // Save the desk to persistent data
                guard self.user.addDesk() else {
                    print("addDesk error, staying in BTConnectView")
                    return
                }
                // Begin searching for the desk
                self.bt.connectToDevice(device: currDesk)
                
                self.notifyWrongInput = false
                self.showBTConnect = false
            } else {
                //Input is incorrect, inform user and remain in view
                print("incorrect desk info submitted")
                self.notifyWrongInput = true
            }
        }) { // End button action. Button displayed contents:
            Text("Connect").bold()
        } // end Button
    }
    
} // end BTDoneButton


struct BTConnectView_Previews: PreviewProvider {
    static var previews: some View {
        
        let user: UserObservable = UserObservable()
//        user.desks.append(contentsOf: [Desk(name: "test desk 1", deskID: 13371234), Desk(name: "test desk 2", deskID: 56789012)])
        
        return BTConnectView(showBTConnect: .constant(true))
            .environmentObject(user)
    }
}
