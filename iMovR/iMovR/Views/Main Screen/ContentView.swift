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
    @EnvironmentObject var BTController: ZGoBluetoothController
 
    var body: some View {
        GeometryReader { geo in
            TabView(selection: self.$selection){
                HomeView()
                    .padding(0.0)
                .frame(width: geo.size.width,
                       height: geo.size.height * 1.0 / 3.0)
                    
                //.aspectRatio(contentMode: .fit)
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .tag(0)
            
            /*Text("Settings View")
                .font(.title) */
                
            SettingView()
                
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(1)
        }
            
//            .introspectTabBarController { tabV in
//
//            }
            ///geo reader paren
        }
        
        //.edgesIgnoringSafeArea(.top)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
                .environmentObject(UserObservable())
                .environmentObject(ZGoBluetoothController())
    }
}
