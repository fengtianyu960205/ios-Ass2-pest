//
//  PestCD+CoreDataProperties.swift
//  
//
//  Created by 俞冯天 on 6/11/20.
//
//

import Foundation
import CoreData


extension PestCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PestCD> {
        return NSFetchRequest<PestCD>(entityName: "PestCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var pestID: String?
    @NSManaged public var category: String?
    @NSManaged public var pestImage: Data?
    @NSManaged public var users: NSSet?
    

}

// MARK: Generated accessors for users
extension PestCD {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: UserCD)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: UserCD)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
