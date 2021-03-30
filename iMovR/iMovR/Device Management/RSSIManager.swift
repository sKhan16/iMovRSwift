//
//  RSSIManager.swift
//  iMovR
//
//  Created by Michael Humphrey on 3/29/21.
//  Copyright © 2021 iMovR. All rights reserved.
//

import Foundation
import CoreBluetooth

public class RSSIManager
{
    //Dictionary of peripherals to RSSI array
    //used to track short-time readings of RSSI for filtering of outliers
    private var rssiDictionary: [CBPeripheral: Array<NSNumber>] = [:]
    
    
    init()
    {
        
    }
    
    
    
    func getFilteredRSSI(peripheral: CBPeripheral) -> NSNumber?
    {
        guard let rssiArray: [NSNumber] = rssiDictionary[peripheral]
        else { return nil }
        
        let rssiSum: Double =
            rssiArray.map{$0.doubleValue}.reduce(0.0,+)
            //maps [NSNumber] -> [Double], then reduces to sum.
        
        let rssiAvg = rssiSum / Double(rssiArray.count)
        
        return NSNumber(value: rssiAvg)
        //rough implementation, still need to remove outlier values - this only returns the total average
    }
    
    
    
    func addValue(peripheral: CBPeripheral, rssi: NSNumber)
    {
        rssiDictionary.updateValue(<#T##value: Array<NSNumber>##Array<NSNumber>#>, forKey: <#T##CBPeripheral#>)
    }
    
}
