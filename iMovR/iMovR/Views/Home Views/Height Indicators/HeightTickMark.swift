//
//  HeightTickMark.swift
//  iMovR
//
//  Created by Michael Humphrey on 12/11/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

import SwiftUI

struct HeightTickMark: View {
//    @ObservedObject var deviceData: DeviceDataManager
    @Binding var height: Float
//    @Binding var index: Int

    var body: some View {
        if height == Float(-1.0) {
            EmptyView()
        } else {
            ZStack {
                Image(systemName: "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(.degrees(180))
                    .frame(width: 10, height: 10)
                    //.shadow(radius: 5)
                    .foregroundColor(ColorManager.preset)
                    
                Text(String(height))
                    .font(Font.caption.bold())
                    .foregroundColor(ColorManager.gray)
                    .offset(x: 23)
            }
        }
    }
}

struct HeightTickMark_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            HeightTickMark(height: .constant(30.0))
        }
    }
}
