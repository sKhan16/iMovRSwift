//
//  TreadmillData+CoreDataProperties.swift
//  iMovR
//
//  Created by Shakeel Khan on 7/16/21.
//  Copyright © 2021 iMovR. All rights reserved.
//
//

import Foundation
import CoreData


extension TreadmillData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TreadmillData> {
        return NSFetchRequest<TreadmillData>(entityName: "TreadmillData")
    }

    @NSManaged public var treadID: Int64
    @NSManaged public var isLastConnectedTo: Bool
    @NSManaged public var name: String?
    @NSManaged public var presets: Data?
    @NSManaged public var presetNames: Data?

}

extension TreadmillData : Identifiable {

}
