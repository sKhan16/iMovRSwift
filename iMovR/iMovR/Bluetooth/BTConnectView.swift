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
    
    @State private var inputDeskName: String = ""
    @State private var inputDeskID: String = ""
    @Binding var showBTConnect: Bool
    @State var notifyWrongInput: Bool = false
    
    
    var body: some View {
        // Try cocoapod popoverview later
        NavigationView {
            VStack {
                //Text("Connect to a desk:")
                Form {
                    Section(header:
                        Text("Name your desk:")
                            .font(.headline)
                    ) {
                        
                        TextField("desk name", text: $inputDeskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    } //end 'Name' section
                    
                    Section(header: Text("Input desk ID:")) {
                        
                        TextField("desk ID", text: $inputDeskID)
                                .keyboardType(.decimalPad)
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
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @Binding  var inputDeskName: String
    @Binding  var inputDeskID: String
    @Binding var showBTConnect: Bool
    @Binding var notifyWrongInput: Bool
    
    var body: some View {
        Button(action: {
            let deskID: Int = Int(self.inputDeskID) ?? 0
            
            //if (self.inputDeskName != "") && self.verifyIDFormat(id: deskID) {
            if (self.inputDeskName != "") && (self.inputDeskID.count == 8) {
                print("correct desk info submitted")
                //Store user input and exit connect view
                let currDesk = Desk(name: self.inputDeskName, deskID: deskID)
                self.user.currentDesk = currDesk
                self.bt.currentDesk = currDesk
                // Begin searching for the desk
                self.bt.startConnection()
                // Only save the desk permanently if connection is successful
                if self.bt.isConnected {
                    guard self.user.addDesk() else {
                        print("addDesk error, staying in BTConnectView")
                        return
                    }
                } else {
                    print("desk not connected yet when trying addDesk()")
                }
                self.notifyWrongInput = false
                self.showBTConnect = false
            } else {
                //Inform user their input is incorrect and remain in view
                print("incorrect desk info submitted")
                self.notifyWrongInput = true
            }
        }) { //Button contents
            Text("Done").bold()
        }
    }
    
    /*
    func verifyIDFormat(id: Int) -> Bool {
        // Ensures ID is exactly 8 digits long
        var num = id
        var count = 0
        print("num = \(num)")
        while num != 0 {
            let digit = abs(num % 10)
            if (digit != 0) && (id % digit == 0) {
                count += 1
            }
            num = num / 10
        }
        print("Entered \(count) digits for deskID")
        return (count == 8)
    }
    */
}


struct BTConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BTConnectView(showBTConnect: .constant(true))
            .environmentObject(UserObservable())
    }
}
