//
//  HomeView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var user: UserObservable
    var body: some View {
        
        VStack {
                
            Image("imovrLogo")
                .resizable()
                .frame(width: 110, height: 110)
            
            Spacer().frame(height: 70)
            HStack {
                AddPresetButton()
                .padding()
                
                ScrollView(.horizontal) {
                    HStack  {
                        
                        ForEach (0..<self.user.presets.count) { index in
                            PresetButton(name: self.user.presets[index].0, presetVal: self.user.presets[index].1)
                            //self.addPreset()
                        }
                        
//                    PresetButton(name: "Sitting", presetVal: 32.9)
                    }
                    .frame( height: 100)
                }
                Spacer()
                
                
            }
            
            Spacer()
         
        }
        
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
