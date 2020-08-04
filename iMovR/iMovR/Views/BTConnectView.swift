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
                    Section(header: Text("Name your desk:")) {
                        
                        TextField("Desk Name", text: $inputDeskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    }// end 'name' section
                    
                    Section(header: Text("Input desk ID:")) {
                        
                        TextField("Desk ID", text: $inputDeskID)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Section() {
                        if notifyWrongInput {
                            VStack {
                                Text("Invalid field entries. Please give your desk a name and input the 8 digit manufacturer ID.")
                                    .foregroundColor(.red)
                                    .padding()
                                //Spacer()
                            }
                        } else {
                            VStack {
                                Text("Please give your desk a name and input the 8 digit manufacturer ID.\n\nThe manufacturer ID is found underneath the desk. There is a small box with a plug on each end, with a QR sticker. The 8 digit number is printed on this sticker.")
                                    .foregroundColor(.primary)
                                    .padding()
                                //Spacer()
                            }
                        }
                        //Spacer()
                    } // end notification section
                    
                } // end form
                
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
                self.user.currDeskName = self.inputDeskName
                self.user.currDeskID = deskID
                self.user.saveCurrentDesk()
                
                // MARK: Maybe only save the desk permanently if connection is successful
                self.notifyWrongInput = false
                self.showBTConnect = false
                // Begin searching for the desk
                self.bt.currDeskID = deskID
                self.bt.startConnection()
                
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
