//
//  DeviceManagerView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceManagerView: View {
    
    //use z stack popup stuff to get edit device menu(s)
    
    var body: some View {
        VStack {
            Text("Device Manager")
                .font(Font.largeTitle.bold())
                .foregroundColor(Color.white)
                .padding()
            ScrollView {
                Text("Saved Devices")
                    .foregroundColor(Color.white)
                    .font(Font.title2)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Range(0...6)) { index in
                    VStack {
                        DeviceRowView(deviceIndex: index)
                        //.cornerRadius(10.0)
                        .padding(2)
                    }
                }
                    //.border(Color.blue, width: 3)
                    .background(ColorManager.bgColor)
                    .cornerRadius(20.0)
                    //.padding(5)
                    .frame(maxWidth: .infinity)
                
                Text("DiscoveredDevices")
                    .foregroundColor(Color.white)
                    .font(Font.title2)
                    .padding([.leading,.top])
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Range(6...8)) { index in
                    VStack {
                        DeviceRowView(deviceIndex: index)
                            .padding(2)
                    }
                    
                }
                //.border(Color.yellow, width: 3)
                .background(ColorManager.bgColor)
                .cornerRadius(15.0)
                .frame(maxWidth: .infinity)
            }
            .padding(2)
            //.border(Color.red, width: 3)
            
        }//end VStack
    }
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                ZStack {
                    ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                    
                    DeviceManagerView()
                }
                ZStack {
                    ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                    
                    DeviceManagerView()
                }
                .previewDevice("iPhone 6s")
            }
            Group {
                ZStack {
                    ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                    
                    DeviceManagerView()
                }
                ZStack {
                    ColorManager.bgColor.edgesIgnoringSafeArea(.all)
                    
                    DeviceManagerView()
                }
            }
        }
    }
}
