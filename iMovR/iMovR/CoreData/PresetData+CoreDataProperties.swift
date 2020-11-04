//
//  PresetData+CoreDataProperties.swift
//  
//
//  Created by Shakeel Khan on 11/2/20.
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
    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?

}
