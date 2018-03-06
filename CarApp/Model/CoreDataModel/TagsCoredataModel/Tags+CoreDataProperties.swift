//
//  Tags+CoreDataProperties.swift
//  
//
//  Created by GLB-312-PC on 05/01/18.
//
//

import Foundation
import CoreData


extension Tags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tags> {
        return NSFetchRequest<Tags>(entityName: "Tags")
    }

    @NSManaged public var hashtagDescription: String?
    @NSManaged public var uuid: String?
    @NSManaged public var hashtagTitle: String?
     @NSManaged public var isCloudcart : Bool
}
