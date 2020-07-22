//
//  HomeView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    let minHeight: Float = 23.0
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: ZGoBluetoothController
    
    @State private var testHeight: Float = 35.0
    @State var showAddPreset: Bool = false
    
    var body: some View {
        
        //NavigationView {
        
        
        VStack {
                
            Image("imovrLogo")
                .resizable()
                .frame(width: 110, height: 110)
            
            Spacer().frame(height: 70)
            
            ZStack {
//                if self.$showAddPreset.wrappedValue {
//                    AddPresetView(showAddPreset: self.$showAddPreset)
//                } else {
//
//                }
            HStack {
                
                        AddPresetButton(showAddPreset: self.$showAddPreset)
                        .padding()
                
                //.navigationBarTitle("Home screen")
                
                
                ScrollView(.horizontal) {
                    HStack  {
                        
                        //Might want to make presets a struct that is identifiable
                        ForEach (0..<self.user.presets.count, id: \.self) { index in
                            PresetButton(name: self.user.presets[index].0, presetVal: self.user.presets[index].1)
                            //self.addPreset()
                        }
                        
//                    PresetButton(name: "Sitting", presetVal: 32.9)
                    }
                    .frame( height: 100)
                }
                Spacer()
                
                
            }
            //
            }
            
            Spacer()
            HStack {
                Spacer()
                
                //Text(String(testHeight))
                HStack {
                    HeightSlider(testHeight: $testHeight)
                }//.frame(width:250)
                VStack {
                    UpButton(testHeight: $testHeight)
                    .padding()
                    DownButton(testHeight: $testHeight)
                }
            .padding(40)
            }
            //.frame(height: 300)
            Spacer()
         
        //}
            
        //Needed to avoid white space on top, pushing everything downs
            //.navigationBarTitle("")
            //.navigationBarHidden(true)
        
        }
        
    
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserObservable()).environmentObject(ZGoBluetoothController())
    }
}
