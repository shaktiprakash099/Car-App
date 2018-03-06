//
//  Carhandler.swift
//  CarApp
//
//  Created by GLB-312-PC on 01/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseDatabase

   protocol carhandlerdelegate: class {// for optional func we have to declare all the  function with body in extion//
    

      func acceptcarRequest(lat: Double,long : Double)
       func cancallCar( delegateCalled : Bool)
       func ridercancledrequest()
       func driverAccepted(requestaccepted : Bool , drivername : String)
       func drivercancled()
       func updatedriverlocation(lat: Double,lang : Double)
      func updateRiderlocation(lat: Double,lang : Double)
}
extension carhandlerdelegate{

    func acceptcarRequest(lat: Double,long : Double){
        
    }
    func cancallCar( delegateCalled : Bool){
        
    }
    
    func ridercancledrequest(){
        
    }
    
    func driverAccepted(requestaccepted : Bool , drivername : String){
        
    }
    
    func drivercancled(){
        
        
    }
    func updatedriverlocation(lat: Double,lang : Double){
        
    }
    func updateRiderlocation(lat: Double,lang : Double){
        
    }
}

class Carhandler{
    
    private static let _instance = Carhandler();
   
    weak var delegate : carhandlerdelegate?
    var rider = ""
    var driver = ""
    var rider_id = ""
    var driver_id = ""
    static var Instance: Carhandler{
        
        return _instance;
    }
  
    
    //driver cancled request
    func drivercancledride()  {
        Authprovider.Shareinstance.acceptRef.child(driver_id).removeValue()
    }
    
    
    func acceptrideRequest(latitutude :Double,longitude : Double)  {
        let data : Dictionary<String,Any> = [Constants.NAME : driver,Constants.LATITUDE : latitutude,Constants.LONGITUDE: longitude]
        Authprovider.Shareinstance.acceptRef.childByAutoId().setValue(data)
        
    }
    
    func updateDriversLocation(lat : Double, lan : Double)  {
        Authprovider.Shareinstance.acceptRef.child(driver_id).updateChildValues([Constants.LATITUDE: lat,Constants.LONGITUDE: lan])
        
        
    }

    
    func observemessagesfordriver()  {
        //RIDER REQUESTED AN UBER
        Authprovider.Shareinstance.requestRef.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let latitude = data[Constants.LATITUDE] as? Double{
                    
                    if let logitude = data[Constants.LONGITUDE] as? Double{
                        
                        self.delegate?.acceptcarRequest(lat: latitude, long: logitude)
                    }
                }
                if let name = data[Constants.NAME] as? String{
                    self.rider = name;
                }
            }
        })
        
        //when rider cancled ride
        Authprovider.Shareinstance.requestRef.observe(DataEventType.childRemoved, with: { (DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[ Constants.NAME] as? String{
                    if name == self.rider{
                        self.rider = "";
                        self.delegate?.ridercancledrequest()
                        
                    }
                }
            }
            
        })
        
        // RIDER UPDATING LOCATION
        Authprovider.Shareinstance.requestRef.observe(DataEventType.childChanged, with: { (DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                if let latitude = data[Constants.LATITUDE] as? Double{
                    
                    if let logitude = data[Constants.LONGITUDE] as? Double{
                        
                        self.delegate?.updateRiderlocation(lat: latitude, lang: logitude)
                        
                    }
                }
            }
            
        })

        // driver accept car request
        
        Authprovider.Shareinstance.acceptRef.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    if name == self.driver{
                        self.driver_id = DataSnapshot.key;
                        print("the driver id  is \(self.driver_id)");
                    
                    }
                    
                }
            }
            
        })
       // driver cancled  car request
        Authprovider.Shareinstance.acceptRef.observe(DataEventType.childRemoved, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    if name == self.driver{
                      self.delegate?.drivercancled()
                    }
                    
                }
            }
            
        })
    // rider update location 
        
        
    }
   
    
    //FOR RIDER
    func observemessagesforRider()  {
        //RIDER CALLED FOR A RIDE
        Authprovider.Shareinstance.requestRef.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    if name == self.rider{
                        self.rider_id = DataSnapshot.key;
                        print("the value is \(self.rider_id)");
                        self.delegate?.cancallCar(delegateCalled: true)
                    }
                    
                }
            }
        
        })
        //RIDER CANCLED FOR A RIDE
        Authprovider.Shareinstance.requestRef.observe(DataEventType.childRemoved, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    if name == self.rider{
                        self.delegate?.cancallCar(delegateCalled: false)
                    }
                    
                }
            }
            
        })
        
        // Driver accepted request
        Authprovider.Shareinstance.acceptRef.observe(DataEventType.childAdded, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    if self.driver == ""{
                        self.driver = name
                        self.delegate?.driverAccepted(requestaccepted: true, drivername: self.driver)
                    }
                    
                }
            }
            
        })
// Driver cancled
        Authprovider.Shareinstance.acceptRef.observe(DataEventType.childRemoved, with: { (DataSnapshot) in
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                   
                    
                    if name == self.driver{
                        self.driver = ""
                        self.delegate?.driverAccepted(requestaccepted: false, drivername: name)
                    }
                }
            }
            
        })

        //driver updating location
        
        Authprovider.Shareinstance.acceptRef.observe(DataEventType.childChanged, with: { (DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                
                if let name = data[Constants.NAME] as? String{
                    
                    
                    if name == self.driver{
                        if let latitude = data[Constants.LATITUDE] as? Double{
                            
                            if let logitude = data[Constants.LONGITUDE] as? Double{
                                
                                self.delegate?.updatedriverlocation(lat: latitude, lang: logitude)
                             
                            }
                        }

                    }
                }
            }
            
        })
        
        
    }

  
    
    
    //rider request for a ride
    func requestforRide(latitude: Double,logitude : Double)  {
        let data : Dictionary<String,Any> = [Constants.NAME : rider,Constants.LATITUDE : latitude,Constants.LONGITUDE :logitude]
        Authprovider.Shareinstance.requestRef.childByAutoId().setValue(data)
    }
    
    func updateRidersLocation(lat : Double, lan : Double)  {
        Authprovider.Shareinstance.requestRef.child(rider_id).updateChildValues([Constants.LATITUDE: lat,Constants.LONGITUDE: lan])
        
        
    }
    
    //rider cancle request
    func cancleride()  {
        
        Authprovider.Shareinstance.requestRef.child(rider_id).removeValue()
    }

}
