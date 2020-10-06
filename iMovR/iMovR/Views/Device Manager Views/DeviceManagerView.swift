//
//  DeviceManagerView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

//use z stack popup stuff to get edit device menu(s)


struct DeviceManagerView: View {
    var body: some View {
        VStack {
            Text("Device Manager")
                .font(Font.title.bold())
            ScrollView {
                ForEach(Range(1...10)) {_ in
                    VStack {
                        DeviceRowView()
                            .cornerRadius(15.0)
                            .padding()
                        Divider()
                    }
                    
                }
                .border(Color.yellow, width: 3)
                .background(Color.blue)
                .cornerRadius(15.0)
            }
            .padding(10)
            .border(Color.red, width: 3)
/*
            List {
                DeviceRowView()
            }
            List {
                DeviceRowView()
            }
            /* test
            Text("device manager")
            DeviceRowView()
            */
 */
        }
    }
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceManagerView()
    }
}
