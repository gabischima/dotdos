//
//  DDEvent+CoreDataProperties.swift
//  
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//
//

import Foundation
import CoreData


extension DDEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDEvent> {
        return NSFetchRequest<DDEvent>(entityName: "DDEvent")
    }

    @NSManaged public var all_day: Bool
    @NSManaged public var date_begin: NSDate?
    @NSManaged public var date_end: NSDate?
    @NSManaged public var done: Bool
    @NSManaged public var local: String?
    @NSManaged public var note: String?
    @NSManaged public var `repeat`: Bool
    @NSManaged public var title: String?
    @NSManaged public var category: DDCategory?
    @NSManaged public var tag: DDTag?

}
