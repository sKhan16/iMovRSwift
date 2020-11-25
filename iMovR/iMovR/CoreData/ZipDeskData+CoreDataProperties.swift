//
//  ZipDeskData+CoreDataProperties.swift
//  iMovR
//
//  Created by Michael Humphrey on 11/25/20.
//  Copyright © 2020 iMovR. All rights reserved.
//
//

import Foundation
import CoreData


extension ZipDeskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZipDeskData> {
        return NSFetchRequest<ZipDeskData>(entityName: "ZipDeskData")
    }

    @NSManaged public var deskID: Int64
    @NSManaged public var isLastConnectedTo: Bool
    @NSManaged public var name: String
    @NSManaged public var presetHeights: [Float]
    @NSManaged public var presetNames: [String]

}

extension ZipDeskData : Identifiable {

}
