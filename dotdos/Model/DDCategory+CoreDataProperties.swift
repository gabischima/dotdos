//
//  DDCategory+CoreDataProperties.swift
//  
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//
//

import Foundation
import CoreData


extension DDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDCategory> {
        return NSFetchRequest<DDCategory>(entityName: "DDCategory")
    }

    @NSManaged public var color: String?
    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?
    @NSManaged public var notes: NSSet?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for events
extension DDCategory {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: DDEvent)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: DDEvent)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for notes
extension DDCategory {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: DDNote)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: DDNote)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for tasks
extension DDCategory {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: DDTask)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: DDTask)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
