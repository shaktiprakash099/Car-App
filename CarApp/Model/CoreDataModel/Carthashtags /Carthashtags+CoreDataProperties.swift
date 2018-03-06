//
//  Carthashtags+CoreDataProperties.swift
//  
//
//  Created by GLB-312-PC on 01/02/18.
//
//

import Foundation
import CoreData


extension Carthashtags {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Carthashtags> {
        return NSFetchRequest<Carthashtags>(entityName: "Carthashtags")
    }

    @NSManaged public var hashtagId: String?
    @NSManaged public var hashtagName: String?
    @NSManaged public var postCount: Int32

}
