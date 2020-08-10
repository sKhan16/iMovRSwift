//
//  SettingRow.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//  The view for a single row for the settings page

import SwiftUI

struct SettingRow: View {
    
    var name: String
    var id: String
    //var user: UserObservable
    
    var body: some View {
        VStack(alignment: .leading) {
            /*landmark.image
            .resizable()
            .frame(width: 50, height: 50)
            Text(setting.name)*/
            
            Text(name)
                .font(.subheadline)
                .bold()
            //Spacer()
            if(self.id != "") { //should add id on bottom if id isn't 0
                Text("\(self.id)")
                    .font(.subheadline)
                
            }
            //TODO: change font
        }
        
    }
}

struct SettingRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingRow(name: "Test1", id: "1")
    }
}
