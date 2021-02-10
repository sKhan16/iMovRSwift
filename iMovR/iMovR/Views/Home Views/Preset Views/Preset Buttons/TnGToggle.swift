//
//  TnGToggle.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/16/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI


struct TnGToggle: View {
    @EnvironmentObject var user: UserDataManager
    @Binding var showTnGPopup: Bool
        
        
    var body: some View {
        
        let tngBinding = Binding<Bool> (
            get: { return user.tngEnabled },
            set: { user.toggleTNG($0) }
        )
        
        HStack (alignment: .center) {
            Text("Push & Hold")
                .foregroundColor(Color.white)
            
            // changed to require TnG waiver every time user toggles
            //if self.user.agreedToZipDeskWaiver {
            if self.user.tngEnabled {
                Toggle("Sound", isOn: tngBinding).labelsHidden()
            }   
            else {
                Toggle("Sound", isOn: self.$showTnGPopup).labelsHidden()
            }
            
            Text("Touch & Go")
                .foregroundColor(Color.white)
        }
        
    }
}

struct TnGToggle_Previews: PreviewProvider {
    static var previews: some View {
        TnGToggle(showTnGPopup: .constant(false))
    }
}
