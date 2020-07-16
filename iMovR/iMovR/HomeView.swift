//
//  HomeView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/15/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image("imovrLogo")
                .resizable()
                .frame(width: 110, height: 110)
            
            Spacer().frame(height: 70)
            HStack {
                AddPresetButton()
                .padding()
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
