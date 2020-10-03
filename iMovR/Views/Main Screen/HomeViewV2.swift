//
//  HomeViewV2.swift
//  iMovR
//
//  Created by Shakeel Khan on 10/2/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HomeViewV2: View {
    
    @EnvironmentObject var user: UserObservable
    @EnvironmentObject var bt: ZGoBluetoothController
    var body: some View {
        
            Image("imovrLogo")
                .resizable()
        
    }
}

struct HomeViewV2_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewV2()
    }
}
