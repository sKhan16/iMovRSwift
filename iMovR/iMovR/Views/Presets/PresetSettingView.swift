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
        
        List {
            // Need to id with self or else it crashes and can't read the index on delete
            
            if user.presets.count > 0 {
                ForEach(self.user.presets.indices, id: \.self) { index in
                    NavigationLink(destination: EditPreset(currIndex: index)) {
                        SettingRow(name: self.user.presets[index].getName(), id:
                            self.user.presets[index].fHeightToString())
                    }
                    
                }
                .onDelete(perform: removePresets)
            }
            
        }
        .navigationBarTitle(Text("Presets"))
        
    }
    //TODO: Make a seperate file to store desk info
    //}
    
    //Helper function to remove presets
    func removePresets(at offsets: IndexSet) {
        self.user.presets.remove(atOffsets: offsets)
    }
    

    
}



struct PresetSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PresetSettingView()
    }
}
