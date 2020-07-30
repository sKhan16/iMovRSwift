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
    @State var showBTConnect: Bool = false
    
    @State var presetName: String = ""
    @State var presetHeight: Float = 0.0
    
    var body: some View {
        
        VStack {
            Image("imovrLogo")
                .resizable()
                .frame(width: 110, height: 110)
                .padding(.top)
            //Spacer().frame(height: 70)
            //ZStack {
            HStack {
                
                ScrollView(.horizontal) {
                    
                    HStack  {
                        AddPresetButton(showAddPreset: self.$showAddPreset)
                            .padding()
                        //Might want to make presets a struct that is identifiable
                        ForEach (0..<self.user.presets.count, id: \.self) { index in
                            PresetButton(name: self.user.presets[index].0, presetVal: self.user.presets[index].1, presetName: self.$presetName, presetHeight: self.$presetHeight)
                        }
                    }
                    .frame( height: 100)
                } //end ScrollView
                Spacer()
            } //end HStack
        //} //end ZStack
            
            VStack {
            BTConnectButton(showBTConnect: self.$showBTConnect)
                //.padding()
            Spacer()
            HStack {
                Spacer()
                
                HStack {
                    HeightSlider()
                        .padding(.trailing, 60)
                }
                
                VStack {
                    UpButton(testHeight: $testHeight)
                        //.padding()
                    DownButton(testHeight: $testHeight)
                }
                .padding()
                Spacer()
                //.padding()
            }
                Spacer()
        }
            Spacer()
         
        //}
            VStack {
            HoldButton(presetName: self.$presetName, presetHeight: self.$presetHeight)
            }
            .padding(.bottom)
            Spacer()
            
            
        
        }

    }
    
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserObservable()).environmentObject(ZGoBluetoothController())
    }
}
