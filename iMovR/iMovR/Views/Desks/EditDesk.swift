//
//  EditDesk.swift
//  iMovR
//
//  Created by Adrian Yue on 8/7/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct EditDesk: View {
    @EnvironmentObject var user: UserObservable
    
    @State private var deskNameBinding: String = ""
    @State private var deskIDBinding: String = ""
    @State var isInvalidInput: Bool = false
    @State var isSaved: Bool = false
    
    var currIndex: Int
    
    
    var body: some View {
        
        VStack {
            Form {
                if currIndex < self.user.desks.count {
                    Section(header:
                        Text("Edit:  \(self.user.desks[currIndex].name)")
                    ) {
                        
                        TextField("Change desk name?", text: $deskNameBinding)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Change desk ID?", text: $deskIDBinding)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if (self.isInvalidInput) {
                            VStack {
                                Text("Invalid field entries.")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        if (self.isSaved) {
                           VStack {
                                Text("Your changes have been saved.")
                                    .foregroundColor(.green)
                                    .padding()
                                //Maybe add fade out animation
                            }
                        }
                    }
                    
                } else {
                    Text("Desk index error")
                }
            }
        }
        .navigationBarTitle(Text("Edit Desk"), displayMode: .inline)
        .navigationBarItems(trailing:
            editDeskSaveButton(
                deskName: self.$deskNameBinding,
                deskID: self.$deskIDBinding,
                isInvalidInput: self.$isInvalidInput,
                isSaved: self.$isSaved,
                currIndex: self.currIndex )
        )
    }
}


struct editDeskSaveButton: View {
    @EnvironmentObject var user: UserObservable
    
    @Binding var deskName: String
    @Binding var deskID: String
    @Binding var isInvalidInput: Bool
    @Binding var isSaved: Bool
    
    var currIndex: Int
    
    var body: some View {
        Button(action: {
            self.isInvalidInput = false
            
            // Check if deskID changed and is valid
            var newID: Int = 0
            if (self.deskID != "") {
                guard self.deskID.count == 8 else { // Invalid deskID
                    self.isInvalidInput = true
                    self.isSaved = false
                    return
                }
                newID = Int(self.deskID) ?? 0
            }

            // Save changes when input is valid
            if !self.isInvalidInput {
                self.user.editDesk(index: self.currIndex, name: self.deskName, deskID: newID)
                self.isSaved = true
            } else {
                //Inform user their input is incorrect and remain in view
                print("incorrect desk info submitted")
                self.isSaved = false
            }
            
            // Fix double press Done button bug
            //self.mode.wrappedValue.dismiss()
            
        }) {
            Text("Save").bold()
        }
    }
}



struct EditDesk_Previews: PreviewProvider {
    static var previews: some View {
        EditDesk(currIndex: 0)
            .environmentObject(UserObservable())
    }
}
