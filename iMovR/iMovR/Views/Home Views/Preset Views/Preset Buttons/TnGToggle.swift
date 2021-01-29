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
    
    
    
    @State var tngBindingLink: Bool = false
        
        
    @ViewBuilder
    var body: some View {
        
        var tngBinding = Binding<Bool> (
            get: <#T##() -> Bool#>,
            set: <#T##(Bool) -> Void#>
        )
        
        HStack (alignment: .center) {
            Text("Push & Hold")
                .foregroundColor(Color.white)
                
            if self.user.agreedToZipDeskWaiver {
                Toggle("Sound", isOn: self.$isTouchGo).labelsHidden()
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
