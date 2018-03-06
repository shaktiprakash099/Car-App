//
//  ContactModel.swift
//  CarApp
//
//  Created by GLB-312-PC on 14/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import Foundation
class ContactModel{
    
    private var _id = " "
    private var _name = " "
    
    init(id: String, name: String ) {
        _id = id
        _name = name
    }
    
    var name: String{
        get {
            return _name
        }
    }
    
    var id:String{
        get {
            return _id
        }
    }
    
    
}
