//
//  DeviceRowView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceRowView: View {
    var body: some View {
        
        HStack {
            
            Button(
                action:{
                    print("clicked device row")
                }
            ) { Image(systemName: "dot.radiowaves.left.and.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 20, idealWidth: 30, maxWidth: 50)
                .padding(15)
            }
            
            //Spacer()
            Text("Device Name\nDevice ID")
                .frame(minWidth: 100, idealWidth: 150, maxWidth: 200)
            //Spacer()
            Button(
                action:{
                    print("edit device popup activates")
                }
            ) { Image(systemName: "pencil.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 20, idealWidth: 30, maxWidth: 50)
                .padding(15)
                
            }
                
        }
        .background(Color.white)
        .cornerRadius(20)
        //.border(Color.black, width: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
        
    }
}

struct DeviceRowView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceRowView()
    }
}
