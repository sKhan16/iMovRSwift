//
//  SettingView.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  View that holds the Settings list

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView{
            List() {//setting in
                //NavigationLink(destination: //SettingDetail()) {
                NavigationLink(destination: DeskSettingView()) {
                    SettingRow(name: "Desks")
                }
                SettingRow(name: "Presets")
                SettingRow(name: "Account")
                //}
            }
            .navigationBarTitle(Text("Settings"))
        }
        //TODO: Put settings into a seperate json file;
        //make List into a loop
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
