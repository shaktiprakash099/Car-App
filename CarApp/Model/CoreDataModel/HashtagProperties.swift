//
//  HashtagProperties.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 04/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import CoreData
extension HashtagObjects{


    @nonobjc public class func fetchRequest() -> NSFetchRequest<HashtagObjects>{
        return NSFetchRequest<HashtagObjects>(entityName: "HashtagObjects");
    }
    @NSManaged public var uuid: String?
    @NSManaged public  var tagsDescription: String?

}


