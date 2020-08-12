//
//  PresetData+CoreDataProperties.swift
//  iMovR
//
//  Created by Michael Humphrey on 8/4/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//

import Foundation
import CoreData


extension PresetData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PresetData> {
        return NSFetchRequest<PresetData>(entityName: "PresetData")
    }

    @NSManaged public var deskID: Int64
    @NSManaged public var height: Float
    @NSManaged public var name: String
    @NSManaged public var uuid: UUID
    
    var wrappedDeskID: Int {
        Int(deskID)
    }
    
    var wrappedHeight: Float {
        height
    }
    
    var wrappedName: String {
        name
    }
    
    var wrappedUUID: UUID {
        uuid
    }
}
