//
//  SettingDetail.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//  A view showing the details for a preset setting

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
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            
            NavigationLink(destination: EditPreset(showAddPreset: .constant(true), currIndex: currIndex)) {
                /*Button(action: {print("TEST")}) {
                    Text("Edit Name")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .font(.title)*/
                Text("EDIT NAME")
                //}
            
            //.padding()
            }.buttonStyle(PlainButtonStyle())
            
                
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

struct SettingDetail_Previews: PreviewProvider {
    static var previews: some View {
        SettingDetail(currIndex: 0)
    }
}
