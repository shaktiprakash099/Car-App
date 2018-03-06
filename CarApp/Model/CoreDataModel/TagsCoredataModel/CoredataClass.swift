//
//  CoredataClass.swift
//  Coredatademo
//
//  Created by GLB-312-PC on 05/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import CoreData
class Coredatahelper{
    
  static let shareinstance = Coredatahelper()
    var hashtags =  [Tags]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK : Insert tags
    func addTags(descriptions: String,  uuid: String ,title : String ,iscloudcart : Bool) -> Bool{
        
        let tags = Tags(context:context)
        tags.hashtagDescription = descriptions
        tags.uuid = uuid
        tags.hashtagTitle = title
        tags.isCloudcart = iscloudcart

        do {
                    try context.save()
                        print("saveddata")
                        return true
            
                    } catch  {
                        print("error")
                        return false
            }


    }
    
    //MARK: Get All hashtags
    func getallhashtags() -> [Tags]{
        
        do {
           hashtags =  try context.fetch(Tags.fetchRequest())
        } catch  {
            print("Error while retriving data from CoreData")
        }
        return hashtags
    }
    
    
    //MARK : Remove tags
    func removeCloudCarthashtags(uuid : String) -> Bool {
        let request = NSFetchRequest<Tags>(entityName: "Tags")
        do {
            
            let allcloudcartHashtags = try context.fetch(request)
            for cloudtags in allcloudcartHashtags {
                
                if cloudtags.uuid == uuid{
                    context.delete(cloudtags)
                }
                
            }
              do {
                try context.save()
                print("Data successfully saved")
                return true
            
              } catch {
                
                print("Error occured")
                return false
            }
            
        }
        catch{
            print("Error occured ")
            return false
            
        }
    
    }
    
    func updatesavedtags(uuid: String ,tagsTitle : String,tagsDescription: String) -> Bool {
          let request = NSFetchRequest<Tags>(entityName: "Tags")
        do {
            
            let allCloudcartahshtags  = try context.fetch(request)
            
            for savedtags in allCloudcartahshtags {
                if savedtags.uuid == uuid {
                    
                    savedtags.hashtagDescription =  tagsDescription
                    savedtags.hashtagTitle = tagsTitle
                }
                
            }
            
            do {
                try context.save()
                print("Data successfully saved")
                return true
                
            } catch {
                
                print("Error occured")
                return false
            }
            
            
        } catch {
            print("error occred")
            return false
        }
        
    }
    
    
    
    
}
