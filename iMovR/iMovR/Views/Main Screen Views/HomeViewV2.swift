//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State var showAddPreset: Bool = false

    @State var isTouchGo: Bool = false
    
    @State var presetName: String = ""
    @State var presetHeight: Float = 0.0
    
    @State private var showBTConnect: Bool = false
    @State private var testHeight: Float = 35.0
    @State private var progressValue: Float = 0.7
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                Image("imovrLogo")
                    .resizable()
                    .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                    //.padding(.top)
                
                /* why use ZStack? curious. device picker works in the below VStack
                Spacer().frame(height: 70)
                ZStack {
                    HStack {
                        DevicePicker()
                 
                    } //end HStack
                } //end ZStack
                */
                
                VStack {
                    
                    DevicePicker()
                    //BTConnectButton(showBTConnect: self.$showBTConnect)
                        .padding(.bottom, 20)
                    
                    HStack {
                        //Height indicator goes here,,
                        //Or build height indicators into the HeightSlider and remove the Spacer()
                        //HStack {
                            Text(String(format: "%.1f", self.bt.currentHeight))
                                .font(.system(size: 86))
                                .padding(.leading)
                            Text("in")
                                .foregroundColor(ColorManager.textColor)
                                .font(.system(size: 64))
                        //}
                        Spacer()
                        
                        //VStack(alignment: .leading) { // this alignment doesnt seem to change anything
                            //HStack(alignment: .top) {
                                HeightSliderV2(barProgress: self.$progressValue).frame(minWidth: 20,maxWidth: 20, maxHeight: .infinity)// By default slider size is undefined, fills container
                                    //.padding([.top,.bottom], 20)
                            //}
                        //}
                        
                        VStack {
                            //Spacer()
                            UpButton(testHeight: self.$testHeight)
                                .padding(.bottom, 10)
                            DownButton(testHeight: self.$testHeight)
                                .padding(.top, 10)
                            //Spacer()
                        }
                        .padding()
                    }//end HStack
                    
                    Spacer(minLength: 150)//test spacer for preview (accounts for tabView squishing)
                    
                }//end 2nd level VStack
                
                PresetModule(isPaged: false, showAddPreset: self.$showAddPreset)
//                VStack {
//                    HStack {
//                        AddPresetButton(showAddPreset: self.$showAddPreset)
//                    }
//                }
                
                /* dont need touch & go slider/stuff on home page anymore...
                VStack (alignment: .center) {
                Text("Touch & Go")
                    Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
                }
                
                VStack {
                    if self.isTouchGo {
                        TouchGoButton(isTouchGo: self.$isTouchGo,
                            presetHeight:
                            self.$presetHeight)
                    } else {
                    HoldButton(presetName: self.$presetName, presetHeight: self.$presetHeight)
                    }
                }
                //.padding(.bottom)
                //Spacer()
                */
                
            }//end 1st level VStack
        }//end GeoReader
        
    }//end body
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            HomeViewV2()
                .environmentObject(UserObservable())
                .environmentObject(ZGoBluetoothController())
        }
    }
}
