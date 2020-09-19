//
//  DiscoveredDesksView.swift
//  iMovR
//
//  Created by Michael Humphrey on 9/17/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DiscoveredDesksView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: BTConnectView)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle("Connect To Desk")
        }
    }
}

struct DiscoveredDesksView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredDesksView()
    }
}
