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
    @State private var inputDeskID: Int = 0
    @Binding var showBTConnect: Bool
    @State var notifyWrongInput: Bool = false
    
    
    var body: some View {
        // Try cocoapod popoverview later
        NavigationView {
            VStack {
                //Text("Connect to a desk:")
                Form {
                    Section(header: Text("Please input your desk information.")) {
                        HStack {
                            
                            Text("Name:    ")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            TextField("Name your desk", text: $inputDeskName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack {
                            Text("Desk ID:")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            TextField("Manufacturer Desk ID:", value: $inputDeskID, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
            }
            .navigationBarTitle("Connect To Desk", displayMode: .inline)
            .navigationBarItems(
                leading: CloseButton(showSheet: self.$showBTConnect),
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

struct BTDoneButton: View {
    @EnvironmentObject var user: UserObservable
    
    @Binding  var inputDeskName: String
    @Binding  var inputDeskID: Int
    @Binding var showBTConnect: Bool
    @Binding var notifyWrongInput: Bool
    
    var body: some View {
        Button(action: {
            /*
            let height: Float = (self.presetHeight as NSString).floatValue
            if height <= 48.00 && height >= 23.00 {
                self.user.addPreset(name: self.presetName, height: height)
                print("Height is \(height)")
            } else {
                print("height out of bounds!")
            }
             */
            if (self.inputDeskName != "") && self.verifyIDFormat(id: self.inputDeskID) {
                //Store user input and exit connect view
                self.user.currDeskName = self.inputDeskName
                self.user.currDeskID = self.inputDeskID
                self.user.saveCurrentDesk()
                // MARK: Maybe only save the desk permanently if connection is successful
                self.notifyWrongInput = false
                self.showBTConnect = false
            } else {
                //Inform user their input is incorrect and remain in view
                self.notifyWrongInput = true
            }
        }) { //Button contents
            Text("Done").bold()
        }
    }
    
    func verifyIDFormat(id: Int) -> Bool {
        // Ensures ID is exactly 8 digits long
        var num = id
        var count = 0
        while num != 0 {
            let digit = abs(num % 10)
            if (digit != 0) && (id % digit == 0) {
                count += 1
            }
            num = num / 10
        }
        return (count == 8)
    }
}


struct BTConnectView_Previews: PreviewProvider {
    static var previews: some View {
        BTConnectView(showBTConnect: .constant(true))
            .environmentObject(UserObservable())
    }
}
