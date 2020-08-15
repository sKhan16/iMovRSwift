//
//  SettingDetail.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//  A view showing the details for a preset setting

///TODO: Get rid of this view, until we figure out how to delete from button

import SwiftUI

struct SettingDetail: View {
    
    //TODO: Get needed variables
    // var name: String
    //@EnvironmentObject var user: UserObservable
    //TODO: MAKE FUNCTION TO EDIT NAME
    //MAKE FUNCTION TO DELETE PRESET
    //var preset: self.user.presets
    var currIndex: Int
    //var name: String
    @EnvironmentObject var user: UserObservable
    
    @State var canDelete: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {

        VStack {
            
            NavigationLink(destination: EditPreset(currIndex: self.currIndex)) {
                /*Button(action: {print("TEST")}) {
                 Text("Edit Name")
                 .padding()
                 .background(Color.gray)
                 .foregroundColor(.white)
                 .font(.title)*/
                Text("EDIT PRESET")
                //}
                
                //.padding()
            }.buttonStyle(PlainButtonStyle())
            
                .padding()
            
            Button (action: {
                self.showAlert = true
                //if (self.canDelete) {
                    //self.user.presets.remove(at: self.currIndex)
                    //print("Removed")
                    //self.canDelete = false
                //}
                
            }) {
                Text("DELETE PRESET")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Delete preset?"), primaryButton: .default(Text("Confirm")) {
                    if !self.canDelete {
                        self.canDelete = true
                    }
                    if self.canDelete {
                        print("Removed")
                        
                        ///Crashes the app, can't delete from index
                        //self.user.presets.remove(at: self.currIndex)
                        
                        self.canDelete = false
                    }
                    },  secondaryButton: .destructive(Text("Cancel")))
            }
            /*
             
             Button(action: {print("TEST")}) {
             Text("Delete")
             .padding()
             .background(Color.gray)
             .foregroundColor(.white)
             .font(.title)
             }*/
        }
        //.navigationBarTitle(Text(""))
        //.navigationBarHidden(true)
    }
}


struct confirmAlert: View {
    
    @EnvironmentObject var user: UserObservable
    
    @Binding var showAlert: Bool
    @Binding var canDelete: Bool
    //var currIndex: Int
    
    var body: some View {
        Button(action: {
            self.canDelete = true
        }) {
            Text("Confirm")
        }
    }
}

struct SettingDetail_Previews: PreviewProvider {
    static var previews: some View {
        SettingDetail(currIndex: 0)
    }
}
