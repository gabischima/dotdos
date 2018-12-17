//
//  DDTag+CoreDataProperties.swift
//  
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//
//

import Foundation
import CoreData


extension DDTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDTag> {
        return NSFetchRequest<DDTag>(entityName: "DDTag")
    }

    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?
    @NSManaged public var notes: NSSet?
    @NSManaged public var tasks: DDTask?

}

// MARK: Generated accessors for events
extension DDTag {

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
extension DDTag {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: DDNote)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: DDNote)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
