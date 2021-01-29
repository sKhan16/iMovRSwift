//
//  UserData+CoreDataProperties.swift
//  iMovR
//
//  Created by Michael Humphrey on 1/29/21.
//  Copyright © 2021 iMovR. All rights reserved.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var touchAndGoWaiver: Bool
    @NSManaged public var treadmillWaiver: Bool
    @NSManaged public var touchAndGoEnabled: Bool

}

extension UserData : Identifiable {

}
