//
//  DBProvider.swift
//  CarApp
//
//  Created by GLB-312-PC on 14/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol Dbproviderdelegate : class {

    func datareceived(contactdetailsarray: NSArray)

    
}

extension Dbproviderdelegate{
    
    func datareceived(contactdetailsarray: NSArray){
        
    }
}

class DBProvider: NSObject {

    weak var delegate : Dbproviderdelegate?
    private static let _instance =  DBProvider();
    private override init() {
        
    }
    static var Instance : DBProvider{
        return _instance
    }
    
    var dbref:DatabaseReference{
        return Database.database().reference()
    }
    
    var contactreference: DatabaseReference{
        return dbref.child(Constants.CONTACTS)
    }
    
    var messagereference:DatabaseReference{
        return dbref.child(Constants.MESSAGES)
    }
    var mediamessagesreference:DatabaseReference{
        return dbref.child(Constants.MEDIA_MESSAGE)
    }
   
    var storageRef :StorageReference{
        return Storage.storage().reference(forURL: "gs://shaktifirebase.appspot.com")
    }
    
    var imagestorageRef :StorageReference{
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    var videostorageRef :StorageReference{
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    var riderRef : DatabaseReference{
        return dbref.child(Constants.RIDERS)
    }
    
    var driverRef : DatabaseReference{
        
        return dbref.child(Constants.DRIVERS)
    }

    func getUserdetails ()  {
        let finalArray:NSMutableArray = NSMutableArray.init()
        self.driverRef.observe(.value, with: { snapshot in
            
            let Dict = snapshot.value as! NSDictionary
            
            print("items are \(Dict)")
            let arrayofKeys: NSArray = Dict.allKeys as NSArray
            if arrayofKeys.count != 0{
                print("Array is  \(arrayofKeys)")
                
                let finalArray:NSMutableArray = NSMutableArray.init()
                for index in 0 ..< arrayofKeys.count {
                    
                    if let datadict = Dict.object(forKey: arrayofKeys[index]) as? NSDictionary{
                        if let userdetailsDict = datadict.object(forKey: "data") as? NSDictionary{
                            
                            let useremail = userdetailsDict.object(forKey: "email")
                            let useruid = arrayofKeys[index]
                            
                            let data :Dictionary<String ,Any> = [Constants.EMAIL:useremail!,Constants.USER_UID: useruid ];
                            
                            finalArray.add(data)
                        }
                        
                    }
                    
                    
                }
    
                print("final array is\(finalArray)")
                self.delegate?.datareceived(contactdetailsarray: finalArray)
            }
            
            
        })

    
    }
    
    
}
