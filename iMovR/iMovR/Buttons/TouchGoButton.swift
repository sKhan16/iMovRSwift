//
//  TouchGoButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 9/11/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
import SwiftUI

struct TouchGoButton: View {
    @ObservedObject var zipdesk: ZGoZipDeskController
    @Binding var isTouchGo: Bool
    @Binding var presetHeight: Float
    
    var body: some View {
        HStack {
            StartGoButton(zipdesk: self.zipdesk, presetHeight: self.$presetHeight)
            StopGoButton(zipdesk: self.zipdesk)
        }
        
    .padding()
    }
}

struct TouchGoButton_Previews: PreviewProvider {
    static var previews: some View {
        TouchGoButton(zipdesk: ZGoZipDeskController(), isTouchGo: .constant(false), presetHeight: .constant(32.0))
    }
}
