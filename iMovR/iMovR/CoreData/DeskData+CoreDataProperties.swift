//
//  DeskData+CoreDataProperties.swift
//  
//
//  Created by Michael Humphrey on 11/9/20.
//
//

import Foundation
import CoreData


extension DeskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeskData> {
        return NSFetchRequest<DeskData>(entityName: "DeskData")
    }

    @NSManaged public var deskID: Int64
    @NSManaged public var isLastConnectedTo: Bool
    @NSManaged public var name: String
    @NSManaged public var presetNames: [String]
    @NSManaged public var presetHeights: [Float]

}
