//
//  DeskSettingView.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  View that contains list of desks

import SwiftUI

struct DeskSettingView: View {
    var body: some View {
        NavigationView{
            List() {//setting in
                //NavigationLink(destination: //SettingDetail()) {
                NavigationLink(destination: SettingDetail()) {
                SettingRow(name: "Desk 1")
                }
                SettingRow(name: "Desk 2")
                SettingRow(name: "Desk 3")
            }
            .navigationBarTitle(Text("Desks"))
        }
        //TODO: Make a seperate file to store desk info
    }
}

struct DeskSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DeskSettingView()
    }
}
