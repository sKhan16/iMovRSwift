//
//  DeskData+CoreDataProperties.swift
//  iMovR
//
//  Created by Michael Humphrey on 8/4/20.
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
    @NSManaged public var name: String
    @NSManaged public var isLastConnectedTo: Bool
    @NSManaged public var uuid: UUID

}
