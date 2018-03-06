//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by GLB-312-PC on 30/01/18.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var categoryName: String?
    @NSManaged public var categoryIcon: String?
    @NSManaged public var hashtagsEnglish: String?
    @NSManaged public var hashtagRussia: String?
    @NSManaged public var hashtagsAll:String?
    @NSManaged public var ishashtags: Bool

}
