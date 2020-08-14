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
    
    @State private var deskName: String = ""
    @State var isInvalidInput: Bool = false
    @State var isSaved: Bool = false
    
    var currIndex: Int
    var currDesk: Desk
    
    var body: some View {
        VStack {
            Form {
                if currIndex < self.user.desks.count {
                    Section(header:
                        Text(currDesk.name)
                    ) {
                        
                        TextField("\(currDesk.name)", text: $deskName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if (self.isInvalidInput) {
                            VStack {
                                Text("Please type a name.")
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
        .navigationBarTitle(Text("Edit Desk Name"), displayMode: .inline)
        .navigationBarItems(trailing: editDeskSaveButton(deskName: self.$deskName, isInvalidInput: self.$isInvalidInput, isSaved: self.$isSaved, currIndex: self.currIndex))
    }
}


struct editDeskSaveButton: View {
    
    //@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var user: UserObservable
    
    @Binding var deskName: String
    @Binding var isInvalidInput: Bool
    @Binding var isSaved: Bool
    
    var currIndex: Int
    
    var body: some View {
        Button(action: {
            
            if (self.deskName != "") {
                
                //Store new desk name
                self.user.currentDesk.name = self.deskName
                self.user.modifyDeskName(index: self.currIndex, name: self.deskName)
                //self.user.saveCurrentDesk()
                
                // MARK: Maybe only save the desk permanently if connection is successful
                self.isInvalidInput = false
                self.isSaved = true
    
            } else {
                //Inform user their input is incorrect and remain in view
                print("incorrect desk info submitted")
                self.isInvalidInput = true
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
        EditDesk(currIndex: 0, currDesk: Desk(name: "", deskID: 12345678))
            .environmentObject(UserObservable())
    }
}
