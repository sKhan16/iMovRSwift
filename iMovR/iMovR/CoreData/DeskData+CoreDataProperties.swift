//
//  DeskData+CoreDataProperties.swift
//  iMovR
//
//  Created by Shakeel Khan on 9/9/20.
//  Copyright © 2020 iMovR. All rights reserved.
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
    @NSManaged public var name: String?
    @NSManaged public var presets: NSSet?

}

// MARK: Generated accessors for presets
extension DeskData {

    @objc(addPresetsObject:)
    @NSManaged public func addToPresets(_ value: PresetData)

    @objc(removePresetsObject:)
    @NSManaged public func removeFromPresets(_ value: PresetData)

    @objc(addPresets:)
    @NSManaged public func addToPresets(_ values: NSSet)

    @objc(removePresets:)
    @NSManaged public func removeFromPresets(_ values: NSSet)

}
