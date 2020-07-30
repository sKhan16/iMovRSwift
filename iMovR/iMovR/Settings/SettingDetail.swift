//
//  SettingDetail.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//  A view showing the details for a Setting

import SwiftUI

struct SettingDetail: View {
    
    //TODO: Get needed variables
   // var name: String
    
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            Button(action: {print("TEST")}) {
                Text("Choose")
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .font(.title)
            }.padding()
                
            
            
            Button(action: {print("TEST")}) {
                Text("Edit Name")
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .font(.title)
            }
        }
        
    }
}

struct SettingDetail_Previews: PreviewProvider {
    static var previews: some View {
        SettingDetail()
    }
}
