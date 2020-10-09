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
//            HStack {
//
//                DevicePicker()
//
//            } //end HStack
        //} //end ZStack
            
            VStack {
                DevicePicker()
                //BTConnectButton(showBTConnect: self.$showBTConnect)
                //.padding()
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack() {
                    HeightSliderV2()
                        .frame(height: 20)
                        .padding()
                }
                    
//                    VStack (){
//                        Text("Touch & Go")
//                        Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
//                            //.padding()
//                    }.padding(.top)
                }
                
                VStack {
                    UpButton(testHeight: self.$testHeight)
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
struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewV2()
    }
}
