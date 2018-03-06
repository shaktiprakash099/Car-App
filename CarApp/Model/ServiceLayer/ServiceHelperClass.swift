//
//  ServiceHelperClass.swift
//  CoregraphicsConcept
//
//  Created by GLB-312-PC on 28/12/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit

class ServiceHelperClass: NSObject {
    
    static let shareinstance = ServiceHelperClass()
    
    func getPopularHashTags(callBack:@escaping(Any?) -> Void) -> Void{
        guard let url = URL.init(string: "\(Configuration.BASE_URL)") else {
            callBack("Unable to cretae u")
            return
        }
        postRequest(with:url, postBody: "") { (response) in
             print(response)
            callBack(response)
        }
    }
    
    //MARK: post request
    func postRequest(with url:URL, postBody:String, callback: @escaping (Any?) -> Void) -> Void {
        
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 30.0
        defaultConfigObject.timeoutIntervalForResource = 60.0
        
        let session = URLSession.init(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
        
        let params: String! = postBody
        
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"
        
        let data = params.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        urlRequest.httpBody = data
        
        session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            
            
            guard let httpResponse:HTTPURLResponse = urlResponse as? HTTPURLResponse
                else{
                    print("did not get any data")
                    return
                }
            var response : (Any)? = nil
            
            if httpResponse.statusCode == 200 {
                
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
            }
                
            else {
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "error")
                callback(nil)
                return
            }
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
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        urlRequest.httpMethod = "GET"
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            guard    let httpResponse: HTTPURLResponse = response as? HTTPURLResponse
                else {
                    print("Error: did not receive data")
                    return
                  }
            
            var response : (Any)? = nil
            
            if httpResponse.statusCode == 200 {
                print(httpResponse)
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                do {
                    let responseData = try JSONSerialization.jsonObject(with: responseData, options: [JSONSerialization.ReadingOptions.allowFragments])
                    
                      response = responseData
                     callback(response)
                }
                catch _ as NSError {
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    callback(responseString)
                    return
                }
            }
            else {
                print(httpResponse)
                
                guard error == nil else {
                    print("error calling GET on /todos/1")
                    print(error ?? "error")
                    callback(response!)
                    return
                }
                
            }
        }).resume()
    }
    
}
