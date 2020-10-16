//
//  PresetEditPopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditPopup: View {
    @EnvironmentObject var user: UserObservable
    
    @Binding var show: Bool
    
//    @State var editName: String = ""
//    @State var editID: String = ""
    
    var body: some View {
        ZStack{
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
                //.blur(radius: 3.0)
            })
            VStack {
                
                VStack {
                    Text("Preset Settings")
                        .font(Font.title.weight(.medium))
                        .padding(5)
                    Rectangle()
                        .foregroundColor(Color.black)
                        .frame(maxWidth:.infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)

                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.white)
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("Change Preset Name?")
                        .foregroundColor(Color.white)
                        .font(Font.body.weight(.medium))
                        .offset(y:8)
//                    TextField(" new name", text: $editName)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    /*
                     Text("Device ID:")
                     .foregroundColor(Color.white)
                     .font(Font.body.weight(.medium))
                     .padding(.top, 10)
                     .offset(y:8)
                     TextField("change id?", text: $editID)
                     .textFieldStyle(RoundedBorderTextFieldStyle())
                     */
                }
                .padding()
                
                Button(action: {
                    
                    self.show = false
                    print("saving 'preset menu' changes")//add functionality here
                    
                }, label: {
                    Text("Save Changes")
                        .font(Font.title3.bold())
                        .padding()
                        .background(Color.init(red: 0.25, green: 0.85, blue: 0.2))
                        .cornerRadius(27)
                })
                .frame(width:200,height:100)
                
                
            }
            .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
            .padding()
            
        }//end ZStack
        //.onTapGesture { self.deviceIndex = -1 }
        // Goes back when tapped outside of edit window
    }//end Body
}


struct PresetEditPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetEditPopup(show: .constant(true))
        }
    }
}
