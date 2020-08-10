//
//  DeskSettingView.swift
//  iMovR
//
//  Created by Michael Humphrey on 8/6/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeskSettingView: View {
    
    @EnvironmentObject var user: UserObservable
    
    var body: some View {
        
        List {
            
            //AddDeskView()
            //Text("Add desks here")
            //Text("List saved desks to edit here")
            ForEach(self.user.desks.indices, id: \.self) { index in
                NavigationLink(
                    destination: EditDesk(currIndex: index, currDesk: self.user.desks[index])
                ) {
                    SettingRow(name: self.user.desks[index].getName(), id:
                        String(self.user.desks[index].getDeskID()))
                }
                    
                //.onDelete(perform: removePresets)
            } //else { //if there are no desks, ask to add
             //   Text("Add desk?")
                //TODO: ADD DESK VIEW
            //}
            
            //Text("TEST")
        }
        .navigationBarTitle(Text("Desks"))
        
    }
}

struct DeskSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DeskSettingView()
    }
}
