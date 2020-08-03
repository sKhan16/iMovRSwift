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

    @NSManaged public var presets: [(name: String, height: Float)]
    @NSManaged public var desks: [(name: String, deskID: Int)]

}
