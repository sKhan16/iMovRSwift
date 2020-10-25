//
//  DevicePicker.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI



struct DevicePicker: View {
    @State var index: Int = 0
    
    @State var testDevices = ["desk 1", "arm 1", "desk 2"]
    
    var body: some View {
            HStack {
                PickerLeft(index: $index, devices: $testDevices)
                ZStack {
                    Text(testDevices[index]).font(.system(size: 30))
                        .foregroundColor(Color.white)
                }
                PickerRight(index: $index, devices: $testDevices)
            }
            .padding()
    }
}

struct PickerLeft: View {
    @Binding var index: Int
    @Binding var devices: Array<String>
    
    var body: some View {
    Button(action: {
        if index == 0 {
            index = devices.count - 1
        } else {
            index -= 1
        }
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .frame(width: 15)
            }
    }
}

struct PickerRight: View {
    @Binding var index: Int
    @Binding var devices: Array<String>
    
    var body: some View {
    Button(action: {
        if index == devices.count - 1 {
            index = 0
        } else {
            index += 1
        }
            }) {
        Image(systemName: "chevron.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.white)
            .frame(width: 15)
            }
    }
}

struct DevicePicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            DevicePicker()
        }
    }
}
