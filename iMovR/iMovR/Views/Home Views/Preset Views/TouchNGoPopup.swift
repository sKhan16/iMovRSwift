//
//  TouchNGoPopup.swift
//  iMovR
//
//  Created by Michael Humphrey on 1/6/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import SwiftUI

struct TouchNGoPopup: View {
    @EnvironmentObject var user: UserDataManager
    @Binding var showTnGPopup: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(ColorManager.bgColor)
                .opacity(0.75)
                //.edgesIgnoringSafeArea(.top)
                .onTapGesture {}

            VStack {
                
                Text("Disclaimer")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(10)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 1)
                    .shadow(color: .white, radius: 2)
                
                Text("Jar Jar Binks was a Gungan male military commander and politician who played a key role during the Invasion of Naboo and the Clone Wars that culminated in the fall of the Galactic Republic and the rise of the Galactic Empire. Once an outcast from Gungan society due to his clumsy behaviour, he regained favour with his people by helping secure an alliance between the Gungan boss Rugor Nass and Queen Padmé Amidala of Naboo.")
                    .foregroundColor(.white)
                    .padding(10)
                
                Spacer()
                
                HStack {
                    
                    //DenyButton
                    Button(
                        action: {
                            //idk
                            guard self.user.setTNGWaiver(false) else {
                                print("TouchNGoPopup error: user.setTNGWaiver(false) failed")
                                return
                            }
                            self.isTouchGo = false
                            self.showTnGPopup = false
                            print("User has rejected TNG Waiver...")
                        },
                        label: {
                            Text("Deny")
                                .font(Font.title2)
                                .foregroundColor(Color.white)
                        }
                    )
                    .frame(width: 100, height: 45)
                    .background(Color.red)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .padding(5)
                    
                    //ConfirmButton
                    Button(
                        action: {
                            guard self.user.setTNGWaiver(true) else {
                                print("TouchNGoPopup error: user.setTNGWaiver(true) failed")
                                return
                            }
                            self.isTouchGo = true
                            self.showTnGPopup = false
                        },
                        label: {
                            Text("I Agree")
                                .font(Font.title2)
                                .foregroundColor(Color.white)

                        }
                    )
                    .frame(width: 100, height: 45)
                    .background(ColorManager.yesGreen)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 1)
                        
                    )
                    .padding(5)
                }
                .frame(width: 250, height: 55)
                .padding(.bottom, 10)
                
            }
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 430, idealHeight: 430, maxHeight: 430, alignment: .top).fixedSize(horizontal: true, vertical: true)
                .background(RoundedRectangle(cornerRadius: 25).fill(ColorManager.bgColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 1)
                        .shadow(color: .white, radius: 2)
                )
                
                .padding()
            
        }//end ZStack
    }//end body
}

struct TouchNGoPopup_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            ColorManager.bgColor.edgesIgnoringSafeArea(.all)
            
            HomeViewV2(
                zipdeskUI: ZGoZipDeskController(),
                data: DeviceDataManager(test: true)!
            ).environmentObject(DeviceBluetoothManager(previewMode: true)!).environmentObject(UserDataManager())
            
            TouchNGoPopup(showTnGPopup: .constant(true))
                .environmentObject(UserDataManager())
            
        }
    }
}
