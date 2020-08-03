//
//  UserData+CoreDataProperties.swift
//  
//
//  Created by Shakeel Khan on 8/3/20.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var presets: String?
    @NSManaged public var attribute: NSObject?
    @NSManaged public var attribute1: NSObject?

}
