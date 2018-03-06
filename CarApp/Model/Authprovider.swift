//
//  Authprovider.swift
//  CarApp
//
//  Created by GLB-312-PC on 31/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

typealias loginHandler = (_  msg: String? ) ->Void;

struct LoginErrorcode {
    static let INVALID_EMAIL = "Invalid Email address ,Please provide a valid ekmail adderss"
    static let WRONG_PASSWORD = "Wrong password ,Please enter  a correct password"
    static let USER_NOT_FOUND = "Invalid Email address ,Please provide a valid ekmail adderss"
    static let EMAIL_EXITS = "Email Alredy in use ,Please provide another  valid email adderss"
    static let WEAK_PASSWORD = "Please provide a strong password"
    static let CONNECTING_PROBLEM = "not able to connect to database"
}
class Authprovider{
    
    private static let shareinstance = Authprovider();
    static var Shareinstance:Authprovider{
        return shareinstance;
    }
    var dbref : DatabaseReference{
        
        return Database.database().reference()
    }
    var riderRef : DatabaseReference{
        return dbref.child(Constants.RIDERS)
    }
    
    var driverRef : DatabaseReference{
        
        return dbref.child(Constants.DRIVERS)
    }
    
    var requestRef :DatabaseReference{
        
        return dbref.child(Constants.CAR_REQUEST)
    }
    
    var acceptRef: DatabaseReference{
        
        return dbref.child(Constants.CAR_ACCEPTED)
    }
    func saveriderinfo(withId: String, email : String,password : String)  {
        let data :Dictionary<String ,Any> = [Constants.EMAIL:email,Constants.PASSWORD: password ,Constants.isRider : true];
        
        riderRef.child(withId).child(Constants.DATA).setValue(data)
    }
    
    func savedriverinfo(withId: String, email : String,password : String)  {
        let data :Dictionary<String ,Any> = [Constants.EMAIL:email,Constants.PASSWORD: password ,Constants.isRider : false];
        
        driverRef.child(withId).child(Constants.DATA).setValue(data)
    }
    
    }











