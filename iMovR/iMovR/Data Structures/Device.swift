//
//  Device.swift
//  iMovR
//
//  Created by Michael Humphrey on 10/7/20.
//  Copyright © 2020 iMovR. All rights reserved.
//

/**
#Device.swift
    is the superclass of all supported iMovR app Bluetooth devices
    **Supported Devices:**
    - ZGo ZipDesk by iMovR
 
    *Support in future for: *
    - *Linak Lander Desks*
    - *Linak Monitor Arms*
    - *Desk Treadmills*
*/

import Foundation
import CoreBluetooth

class Device {
    
    // what properties do all devices need to test connection status, etc?
    
    let peripheral: CBPeripheral?
    
    init(devicePeripheral: CBPeripheral?) {
        self.peripheral = devicePeripheral
    }
}
