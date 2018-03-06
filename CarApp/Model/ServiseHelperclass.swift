//
//  ServiseHelperclass.swift
//  WeatherAppSwift
//
//  Created by GLB-312-PC on 19/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit

class ServiseHelperclass: NSObject {

    func getweatherinformationofCity(cityname: NSString,callback : @escaping (Any?) -> Void) -> Void {
       guard let url = URL.init(string: "http://api.apixu.com/v1/current.json?key=2337278787114c4e9a145025171908&q=\(cityname)") else {
        callback("Unable to create url ")
        return
         }
       getRequest(with: url) { (postRespose) in
        callback(postRespose)
        }
        
    }
    
    func getdestinationaddress(name: NSString,callback : @escaping (Any?) -> Void) -> Void {
        guard let url = URL.init(string: "http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(name)") else {
            callback("Unable to create url ")
            return
        }
        getRequest(with: url) { (postRespose) in
            callback(postRespose)
        }
        
    }

    
       //MARK: post request
    private func postRequest(with url:URL, postBody:NSString, callback: @escaping (Any?) -> Void) -> Void {
        
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 30.0
        defaultConfigObject.timeoutIntervalForResource = 60.0
        
        let session = URLSession.init(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
        
        let params: NSString! = postBody
        
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"
        
        let data = params.data(using: String.Encoding.utf8.rawValue)
        urlRequest.httpBody = data
        
        session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            
            var response : (Any)? = nil
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "error")
                callback(nil)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let responseData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                response = responseData
                callback(response)
            } catch _ as NSError {
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                callback(responseString)
                return
            }
        }).resume()
    }
    
    //MARK: get request
     func getRequest(with url: URL, callback: @escaping (Any?) -> Swift.Void) -> Void {
        
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 30.0
        defaultConfigObject.timeoutIntervalForResource = 60.0
        
        let session = URLSession.init(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
        
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "GET"
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            var response : (Any)? = nil
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "error")
                callback(response!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                let responseData = try JSONSerialization.jsonObject(with: responseData, options: [JSONSerialization.ReadingOptions.allowFragments])
                
                response = responseData
                callback(response)
            } catch _ as NSError {
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                callback(responseString)
                return
            }
        }).resume()
    }
  
    
    
    
}
