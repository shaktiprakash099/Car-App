//
//  Singletone.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 09/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

class Singletone: NSObject {
    
static let share = Singletone()
    var cloudArray :[String] = []
    var bannerUrl : String?
    var bannerADdetailArray = [bannerADdetails]()
    var mainhashtagDetails = [Category]()
    var categorySelectedIndex = 0
    var subcategorySelectedIndex = 0
    var bannerADimageArray = ["AddbannerOne","AddbannerTwo","AddbannerThree","AddbannerFour"]
    var searchbartextfieldText:String = ""
    var searchcontrollerSelectedString:String = ""
    func openinstagramAction(){
        
        let instagramHooks = "instagram://"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(instagramUrl! as URL)
            }
            
        } else {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
            }
            
            //redirect to safari because the user doesn't have Instagram
            
        }

    }
    
    //saved preffered langugeoption
    
    func setPreffredLanguageOption(preferedValue:Int){
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: Configuration.PREFFREDLANGUAGE){
            print("Here you will get saved value \(savedValue)")
               userdefaults.set(preferedValue, forKey: Configuration.PREFFREDLANGUAGE)
        } else {
            print("No value in Userdefault,Either you can save value here or perform other operation")
            userdefaults.set(preferedValue, forKey: Configuration.PREFFREDLANGUAGE)
        }
        
    
    }
    
    //MARK: to get random number
    
    func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 0...3) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    
}
