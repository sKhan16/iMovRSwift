//
//  DeviceManagerView.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/5/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct DeviceManagerView: View {
    var body: some View {
        VStack {
            Text("device manager")
            DeviceRowView()
        }
    }
}

struct DeviceManagerView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceManagerView()
    }
}
