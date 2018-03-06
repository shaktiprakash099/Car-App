//
//  CartHashtagsHandler.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 01/02/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import CoreData
class CarthashtagHandler  {
    
       static let shared  = CarthashtagHandler()
       var cartHashtags  = [Carthashtags]()
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       let persistentCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
    
    
    
    func addtoCloudCart(hashtagName: String, hashtagId:String ,hashtagCount: Int32)->Bool {

           let cloudcarthashtags = Carthashtags(context: context)
            cloudcarthashtags.hashtagId = hashtagId
            cloudcarthashtags.hashtagName = hashtagName
            cloudcarthashtags.postCount = hashtagCount
        
            do {
                   try context.save()
                   print("Data inserted successfully ")
                   return true
            
               } catch {
                    print("Error Occured while saving data ")
                
                return false
              }
         }
    
    func getallCloudcartahshtags() -> [Carthashtags] {
        
        do {
            cartHashtags = try context.fetch(Carthashtags.fetchRequest())
            
        }  catch {
            
            print("Error while retriving  data from core data")
        }
        
        return cartHashtags
     
    }
    
    
    //MARK : delete all hashtags 
    func deleteallHashtags()->Bool{
        
   
        let request = NSFetchRequest<Carthashtags>(entityName: "Carthashtags")
        let deleterequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<NSFetchRequestResult> )
        do {
            try persistentCoordinator.execute(deleterequest, with: context)
            print("successfully deleted all the records ")
              return true
         
         } catch let error as NSError {
            print("Error occured while saving data \(error)")
            return false
        }

   
    }
    
    
    func removehashtagsfromCloudcart(hashtagid : String) -> Bool {
        
        let request = NSFetchRequest<Carthashtags>(entityName: "Carthashtags")
        
        do {
            // fetch all cloud cart hashtsgs details
            let allhashtags = try context.fetch(request)
            for carttags in allhashtags {
                
                if carttags.hashtagId == hashtagid{
                    context.delete(carttags)
                    print("Data deleted  successfully")
                }
            }
            
            do {
                try context.save()
                print("Data successfully saved ")
                return true
                
            } catch {
                print("Error occured while saving data \(error)")
                return false
            }

        }
        catch {
            
            print("Error occred while deleting ")
            return  false
        }
       
    }
    
    
}
