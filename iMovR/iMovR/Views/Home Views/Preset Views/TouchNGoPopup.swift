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

/// Not needed. Uses the popup behind it. Might need if we use this popup anywhere other than the preset settings pop up
            
//            Rectangle()
//                .fill(ColorManager.bgColor)
//                .opacity(0.75)
//                .edgesIgnoringSafeArea(.top)
//                .onTapGesture {}

            VStack {
                
                Text("Disclaimer")
                    .font(Font.largeTitle.bold())
                    .foregroundColor(ColorManager.buttonPressed)
                    .padding(10)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 1)
                    .shadow(color: ColorManager.buttonPressed, radius: 2)
                
                ScrollView
                {
                    Text("Terms and Conditions for Use of the Desk Control App\n\nBy downloading or using the app, these terms will automatically apply to you. Therefore, you should make sure that you read them carefully before using the app.\n\nRestrictions: We are offering you this app, without cost, to use for your own personal use, but you should be aware that you cannot send it on to anyone else. You are not permitted to, in any way, copy or modify the app, any part of the app or the trademarks. You are not allowed to attempt to extract the source code of the app, to translate the app into other languages or make derivative versions. The app itself, all the trademarks, copyright, database rights and other intellectual property rights related to it belong to iMovR A/S or supplied under license to a supplier.\n\nChanges: The supplier is committed to ensure that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason.\n\nData: The app stores and processes data (including personal data) that you have provided to us. It is your responsibility to keep your phone and access to the app secure.\n\nLimitation of liability: You should be aware that there are certain things for which the supplier will not take responsibility. Certain functions of the app, such as the ability to communicate to the iMovR Bluetooth device, will require the app to have a Bluetooth connection. The supplier cannot take responsibility for the app not working at full functionality if you do not have access to Bluetooth.\n\nUpdates: At some point we may wish to update the app, as we know that the app, in a general sense, is not error-free or without defects. The app is currently available on iOS. The requirements for these systems (and for any additional systems to which we decide to extend the app's availability) may change, and you will need to download the updates if you want to keep using the app. We do not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you must promise to always accept updates to the application when they are offered to you.\n\nTermination: We may also wish to stop providing the app, and may terminate use of it at any time without providing notice of its termination to you. Unless we tell you otherwise, upon termination: (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app; and (c) if needed, delete it from your device.\n\nSafety warning: When using the app you obtain a wireless connection to remote control your desk or application. You have to bear the following safety instructions in mind when using the app as a remote control:\n\nWarning: Always have your desk/application in sight while it is operating. Be alert to potential danger while operating the desk/application using the wireless remote control. Watch out for objects under the desk/application while driving down. Failure to comply with these instructions may result in accidents involving serious personal injury.\n\nEU Machinery Directive: If you are using the app as a wireless remote control within the EU, we must kindly inform you that your application for use of the desk control app may be subject to the EU Machinery Directive. To the best of our knowledge, an office desk falls within the Directive, whereas other applications may not be subject to the Directive. The Directive outlines certain limitations in terms of change of the machinery, and adding an app-based remote control could constitute a change of machinery. If you have any questions in relation to the EU Machinery Directive and its application to the app, please contact us via www.imovr.com.")
                        .foregroundColor(ColorManager.buttonPressed)
                        .padding(10)
                    
                    Spacer()
                    
                    HStack {
                        
                        //DenyButton
                        Button(
                            action: {
                                /*
                                 guard self.user.setTNGWaiver(false) else {
                                 print("TouchNGoPopup error: user.setTNGWaiver(false) failed")
                                 return
                                 }
                                 */
                                _=self.user.toggleTNG(false)
                            // changed above for altered TnG waiver
                                
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
                                .stroke(ColorManager.buttonPressed, lineWidth: 1)
                        )
                        .padding(5)
                        
                        //ConfirmButton
                        Button(
                            action: {
                                /*
                                guard self.user.setTNGWaiver(true) else {
                                    print("TouchNGoPopup error: user.setTNGWaiver(true) failed")
                                    return
                                }
                                */
                                _=self.user.toggleTNG(true)
                            // changed above for altered TnG waiver
                                
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
                                .stroke(ColorManager.buttonPressed, lineWidth: 1)
                            
                        )
                        .padding(5)
                    }
                    .frame(width: 250, height: 55)
                    .padding(.bottom, 10)
                }//end ScrollView
            }
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300, minHeight: 450, idealHeight: 450, maxHeight: 450, alignment: .top).fixedSize(horizontal: true, vertical: true)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 25).stroke(ColorManager.buttonPressed, lineWidth: 1)
                        .shadow(color: ColorManager.buttonPressed, radius: 2)
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
