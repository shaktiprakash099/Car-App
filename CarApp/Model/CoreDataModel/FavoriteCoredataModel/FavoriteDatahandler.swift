//
//  FavoriteDatahandler.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 30/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import Foundation
import  CoreData
class Favoritehandler {
    static let shared = Favoritehandler()
    var favorites = [Favorites]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addTofavorites(categoryiconString: String, categoryid : Int32 ,categoryname : String ,englishhashtagsArrayString : String ,russianhashtagsArrayString: String ,hashtagsAllArrayString: String ,ishashtags : Bool )->Bool{
        
        let favoritehashtags = Favorites(context: context)
        favoritehashtags.categoryIcon = categoryiconString
        favoritehashtags.categoryId = categoryid
        favoritehashtags.categoryName = categoryname
        favoritehashtags.hashtagsEnglish = englishhashtagsArrayString
        favoritehashtags.hashtagRussia = russianhashtagsArrayString
        favoritehashtags.hashtagsAll = hashtagsAllArrayString
        favoritehashtags.ishashtags = ishashtags
        
        do {
            try context.save()
            print("Data added favorite lists ")
            return true
            
        } catch {
            print("Error occured while saving data")
            return false
        }
        
    }
    
    func getallFavoritehashtags() -> [Favorites]{
        do {
            favorites =  try context.fetch(Favorites.fetchRequest())
        } catch  {
            print("Error while retriving data from CoreData")
        }
        
        return favorites
        
    }
    
    func removeFromfavoriteList(categoryId : Int32) -> Bool {
        
        
        let request =  NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do {
            // fetch all favorites Coredata model
            let allFavorites = try context.fetch(request)
            for favorites in allFavorites {
                
                if favorites.categoryId == categoryId {

                        context.delete(favorites)
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
        
        } catch {
    
            print("Error occured while deleting ")
            return  false
            
        }
    }
    
}
