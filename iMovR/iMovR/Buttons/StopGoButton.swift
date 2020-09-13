//
//  StopGoButton.swift
//  iMovR
//
//  Created by Shakeel Khan on 9/11/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct StopGoButton: View {
    var body: some View {
        Button(action: {
                
            }) {
            Text("Stop")
            .fontWeight(.bold)
            .font(.title)
                .frame(minWidth: 0, maxWidth: 250)
                .padding()
            .background(Color.red)
            .cornerRadius(40)
            .foregroundColor(.white)
            //.padding(10)
            /*.overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.purple, lineWidth: 0)
            )*/
            }
    }
}

struct StopGoButton_Previews: PreviewProvider {
    static var previews: some View {
        StopGoButton()
    }
}
