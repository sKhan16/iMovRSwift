//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: ZGoBluetoothController

    @State var showAddPreset: Bool = false
    @State var showBTConnect: Bool = false
    @State var isTouchGo: Bool = false
    
    @State var presetName: String = ""
    @State var presetHeight: Float = 0.0
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Image("imovrLogo")
                    .resizable()
                    .frame(width: geo.size.width * 0.719, height: geo.size.height * 0.8)
                HStack {
                    
                }
            }
        }
        
    }
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewV2()
    }
}
