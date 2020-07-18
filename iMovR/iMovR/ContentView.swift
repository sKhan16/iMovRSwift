//
//  ContentView.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/13/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @EnvironmentObject var user: UserObservable
 
    var body: some View {
        
        TabView(selection: $selection){
            
            HomeView()
                    
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            Text("Settings View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
