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
    
    @State var editIndex: Int = -1
    @State var editPresetName: String = ""
    @State var editPresetHeight: String = ""
    
    var body: some View {
        ZStack{
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
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
                
               // Display Presets List
                if self.editIndex == -1  {
                    VStack {
                        Text("List of presets")
                        ForEach(Range(0...5)) { index in
                            VStack {
                                Button(action: { self.editIndex = index }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor)
                                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 1))
                                        HStack {
                                            Text("Edit Preset \(index+1):")
                                            Text(String(self.user.testPresets[index]))
                                        }
                                        
                                    }
                                })
                                .accentColor(.white)
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 5)
                            }
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("Change Preset Name?")
                            .foregroundColor(Color.white)
                            .font(Font.body.weight(.medium))
                            .offset(y:8)
                        
                        VStack(alignment: .leading) {
                            
                            Text("Change Preset \(self.editIndex+1) Name?")
                                .foregroundColor(Color.white)
                                .font(Font.body.weight(.medium))
                                .offset(y:8)
                            TextField(" new name", text: $editPresetName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Text("Change Preset \(self.editIndex+1) Height?")
                                .foregroundColor(Color.white)
                                .font(Font.body.weight(.medium))
                                .offset(y:8)
                            /// Fix textfield to work with Float
                            TextField(" new height", text: self.$editPresetHeight)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                        
                        //PresetSettingView()
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
                .environmentObject(UserObservable())
        }
    }
}
