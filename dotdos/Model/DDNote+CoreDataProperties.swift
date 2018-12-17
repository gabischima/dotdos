//
//  DDNote+CoreDataProperties.swift
//  
//
//  Created by Gabriela Schirmer Mauricio on 01/04/18.
//
//

import Foundation
import CoreData


extension DDNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DDNote> {
        return NSFetchRequest<DDNote>(entityName: "DDNote")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var category: DDCategory?
    @NSManaged public var tag: DDTag?

}
