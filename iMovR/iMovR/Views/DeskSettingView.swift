//
//  DeskSettingView.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  View that contains list of desk presets

import SwiftUI

struct DeskSettingView: View {
    
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
       // NavigationView{
            List(0..<self.user.presets.count) { index in
                //NavigationLink(destination: //SettingDetail()) {
                NavigationLink(destination: SettingDetail(currIndex: index)) {
                    SettingRow(name: self.user.presets[index].0, id: //self.user.currDeskID)
                        Int(self.user.presets[index].1))
                }
            }
            .navigationBarTitle(Text("Desks"))
            //.navigationBarHidden(true)
        }
        //TODO: Make a seperate file to store desk info
    //}
}

struct DeskSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DeskSettingView()
    }
}
