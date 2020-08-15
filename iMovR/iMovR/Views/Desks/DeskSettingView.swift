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
            if user.desks.count > 0 {
                ForEach(self.user.desks.indices, id: \.self) { index in
                    NavigationLink(destination:
                        EditDesk(currIndex: index)) {
                        SettingRow(name: self.user.desks[index].name, id:
                            String(self.user.desks[index].id))
                    }
                }
               .onDelete(perform: removeDesks)
                //else { //if there are no desks, ask to add
            }
                
             //   Text("Add desk?")
                //TODO: ADD DESK VIEW
            //}
            
            //Text("TEST")
        }
        .navigationBarTitle(Text("Desks"))
        
    }
    
    //Helper function to remove desks
    func removeDesks(at offsets: IndexSet) {
        
        offsets.sorted(by: > ).forEach { (i) in
            self.user.removeDesk(index: i)
        }
    }
}

struct DeskSettingView_Previews: PreviewProvider {
    static var previews: some View {
        DeskSettingView()
    }
}
