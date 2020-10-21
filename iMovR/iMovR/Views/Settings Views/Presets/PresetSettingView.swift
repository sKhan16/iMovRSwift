//
//  DeskSettingView.swift
//  iMovR
//
//  Created by Adrian Yue on 7/30/20.
//  Copyright © 2020 iMovR. All rights reserved.
//  View that contains list of desk presets

///TODO: Edge case checks

import SwiftUI

struct PresetSettingView: View {
    
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
        List {
            // Need to id with self or else it crashes and can't read the index on delete
            
            if user.presets.count > 0 {
                ForEach(self.user.testPresets.indices, id: \.self) { index in
                    NavigationLink(destination: EditPreset(currIndex: index)) {
                        SettingRow(name: "\(self.user.testPresets[index])", id:
                            "\(self.user.testPresets[index])")
                    }
                    
                }
                .onDelete(perform: removePresets)
            }
            
        }
        .navigationBarTitle(Text("Presets"))
    }
        
    }
    //TODO: Make a seperate file to store desk info
    //}
    
    //Helper function to remove presets
    func removePresets(at offsets: IndexSet) {
        
        offsets.sorted(by: > ).forEach { (i) in
            self.user.removePreset(index: i)
        }
        //self.user.presets.remove(atOffsets: offsets)
    }
    

    
}



struct PresetSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PresetSettingView()
    }
}
