//
//  UserCD+CoreDataProperties.swift
//  
//
//  Created by 俞冯天 on 6/11/20.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var userID: String?
    @NSManaged public var age: Int32
    @NSManaged public var gender: String?
    @NSManaged public var address: String?
    @NSManaged public var nickName: String?
    @NSManaged public var pestlist: NSSet?

}

// MARK: Generated accessors for pestlist
extension UserCD {

    @objc(addPestlistObject:)
    @NSManaged public func addToPestlist(_ value: PestCD)

    @objc(removePestlistObject:)
    @NSManaged public func removeFromPestlist(_ value: PestCD)

    @objc(addPestlist:)
    @NSManaged public func addToPestlist(_ values: NSSet)

    @objc(removePestlist:)
    @NSManaged public func removeFromPestlist(_ values: NSSet)

}
