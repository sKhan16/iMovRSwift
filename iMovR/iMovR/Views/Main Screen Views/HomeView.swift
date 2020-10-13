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
    //a
    @State private var testHeight: Float = 35.0
    @State var showAddPreset: Bool = false
    @State var showBTConnect: Bool = false
    @State var isTouchGo: Bool = false
    
    @State var presetName: String = ""
    @State var presetHeight: Float = 0.0
    
    var body: some View {
        GeometryReader { geo in
        
        VStack {
            //Spacer()
            //VStack {
                Image("imovrLogo")
                    .resizable()
                    .frame(width: geo.size.width / 6, height: geo.size.height / 10)
                    //.padding(.top)
                //}
            
            //Spacer().frame(height: 70)
            //ZStack {
            HStack {
                
                ScrollView(.horizontal) {
                    
                    HStack  {
                        AddPresetButton(index: 0, showAddPreset: self.$showAddPreset)
                            .padding()
                        //Might want to make presets a struct that is identifiable
                        ForEach (0..<self.user.presets.count, id: \.self) { index in
                            PresetButton(name: self.user.presets[index].getName(), presetVal: self.user.presets[index].getHeight(), presetName: self.$presetName, presetHeight: self.$presetHeight)
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
                VStack(alignment: .leading) {
                    HStack() {
                    HeightSlider()
                        .padding(.trailing, 60)
                }
                    
                    VStack (){
                        Text("Touch & Go")
                        Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
                            //.padding()
                    }.padding(.top)
                }
                
                VStack {
                    UpButton(testHeight: self.$testHeight)
                        //.padding()
                    DownButton(testHeight: self.$testHeight)
                }
                .padding()
                //Spacer()
                //.padding()
            }
                Spacer()
        }
            //Spacer()
         
        //}

//            VStack (alignment: .center) {
//            Text("Touch & Go")
//                Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
//            }
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
            
            
        
        }

    }
    ///Geo reader end paren
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserObservable()).environmentObject(ZGoBluetoothController())
    }
}
