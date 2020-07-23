//
//  BTConnectButton.swift
//  iMovR
//
//  Created by Michael Humphrey on 7/22/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct BTConnectButton: View {
    
    @Binding var showBTConnect: Bool
    
    var body: some View {
        
        VStack {
            Text("Connection Status")
                .padding()
            
            Button(action: {
                self.showBTConnect = true
            }) {
                VStack {
                    Text("BT connect")
                    .padding()
                        .foregroundColor(.black)
                        .background(Color(red: 227/255, green: 230/255, blue: 232/255))
                    .cornerRadius(90)
                    .shadow(radius: 5)
                }
            }
    }
    }
}

struct BTConnectButton_Previews: PreviewProvider {
    static var previews: some View {
        BTConnectButton(showBTConnect: .constant(true))
    }
}
