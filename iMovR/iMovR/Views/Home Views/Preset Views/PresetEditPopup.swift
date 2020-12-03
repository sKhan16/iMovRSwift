//
//  PresetEditPopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct PresetEditPopup: View {
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding var show: Bool
    @Binding var isTouchGo: Bool
    
    @State var editIndex: Int = -1
    @State var editPresetName: String = ""
    @State var editPresetHeight: String = ""
    @State var isInvalidInput: Bool = false
    @State var isSaved: Bool = false
    
    var body: some View {
        let currDesk = self.bt.zipdesk.getDesk()
        ZStack {
            // Background color filter & back button
            Button(action: {self.show = false}, label: {
                Rectangle()
                    .fill(Color.gray)
                    .opacity(0.2)
                    .edgesIgnoringSafeArea(.top)
            })
            VStack {
               // Display Presets List
                if self.editIndex == -1  {
                    VStack {
                        Text("Preset Settings")
                            .font(Font.title2)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        ForEach(Range(0...5)) { index in
                            VStack {
                                Button(action: { self.editIndex = index }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12).fill(ColorManager.deviceBG)
                                            .frame(height: 40)
                                            //.border(Color.black, width: 3)
                                            //        .overlay(
                                            //            RoundedRectangle(cornerRadius: 20)
                                            //                .stroke(Color.black, lineWidth: 2)
                                            //        )
                                            .shadow(color: .black, radius: 3, x: 0, y: 3)
                                        HStack {
                                            Text("Edit \(currDesk.presetNames[index]):")
                                            Text( (currDesk.presetHeights[index] > -1) ? String(currDesk.presetHeights[index]) : "Empty")
                                        }
                                        
                                    }
                                })
                                .accentColor(.white)
                                .padding([.leading, .trailing], 30)
                                .padding([.top, .bottom], 5)
                            }
                        }
                    }
                    .padding(.top, 5)
                    MovementButton(isTouchGo: self.$isTouchGo)
                        .padding(.bottom)
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
                    
                    editSaveButton(presetName: self.$editPresetName, presetHeight: self.$editPresetHeight, isInvalidInput: self.$isInvalidInput, isSaved: self.$isSaved, currIndex: self.editIndex)
//                    Button(action: {
//
//                        self.show = false
//                        print("saving 'preset menu' changes")//add functionality here
//
//                    }, label: {
//                        Text("Save Changes")
//                            .font(Font.title3.bold())
//                            .foregroundColor(Color.white)
//                            .padding()
//                            .background(ColorManager.preset)
//                            .cornerRadius(27)
//                    })
//                    .frame(width:200,height:100)
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


private struct editSaveButton: View {
    
    //@Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var bt: DeviceBluetoothManager
    
    @Binding  var presetName: String
    @Binding  var presetHeight: String
    @Binding var isInvalidInput: Bool
    @Binding var isSaved: Bool
    
    var currIndex: Int
    
    var body: some View {
        Button(action: {
            var currDesk: Desk = self.bt.zipdesk.getDesk()
            if (self.presetHeight != "") {
                //Converts presetHeight to a float
                let height: Float = (self.presetHeight as NSString).floatValue
                
                //TODO: Change min and max to read values from desk
                if height <= (self.bt.zipdesk.maxHeight) && height >= (self.bt.zipdesk.minHeight) {
                    if (self.presetName != "") {
                        currDesk.presetNames[self.currIndex] = self.presetName
                    }
                    currDesk.presetHeights[self.currIndex] = height
                    self.bt.data.editDevice(desk: currDesk)
                    self.isInvalidInput = false
                    self.isSaved = true
                } else {
                    self.isInvalidInput = true
                    self.isSaved = false
                    print("height out of bounds!")
                }
            } else if (self.presetName != "") {
                currDesk.presetNames[self.currIndex] = self.presetName
                self.bt.data.editDevice(desk: currDesk)
                self.isSaved = true
            }
        }, label: {
            Text("Save Changes")
                .font(Font.title3.bold())
                .foregroundColor(Color.white)
                .padding()
                .background(ColorManager.preset)
                .cornerRadius(27)
        })
        .frame(width:200,height:100)}
    }




struct PresetEditPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            PresetEditPopup(show: .constant(true), isTouchGo: .constant(true))
                .environmentObject(DeviceBluetoothManager())
        }
    }
}
