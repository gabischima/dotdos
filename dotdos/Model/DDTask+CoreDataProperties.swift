//
//  DDTask+CoreDataProperties.swift
//  
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//
//

import Foundation
import CoreData


extension DDTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDTask> {
        return NSFetchRequest<DDTask>(entityName: "DDTask")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var done: Bool
    @NSManaged public var note: String?
    @NSManaged public var `repeat`: Bool
    @NSManaged public var scheduled: Bool
    @NSManaged public var title: String?
    @NSManaged public var urgent: Bool
    @NSManaged public var category: DDCategory?
    @NSManaged public var tag: DDTag?

}
