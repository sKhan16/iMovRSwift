//
//  DeskSettingView.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  View that contains list of desk presets

import SwiftUI

struct PresetSettingView: View {
    
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
       // NavigationView{
        List(self.user.presets, id: \.id) { preset in
                //NavigationLink(destination: //SettingDetail()) {
            NavigationLink(destination: SettingDetail(currPreset: preset)) {
                    SettingRow(name: preset.getName(), id: //self.user.currDeskID)
                        Int(preset.getHeight()))
                }
            }
            .navigationBarTitle(Text("Presets"))

        //.navigationBarHidden(true)
        }
        //TODO: Make a seperate file to store desk info
    //}
}

struct DeskSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PresetSettingView()
    }
}
