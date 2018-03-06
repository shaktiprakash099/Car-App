//
//  APIHelperClass.swift
//  HashTagApp
//
//  Created by GLB-312-PC on 09/01/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit

class APIHelperClass: NSObject {
    static let shareinstance = APIHelperClass()
    
    func getPopularHashTags(completionHandler: @escaping(Response?, Error?) -> Void) -> Void{
        
        let url = URL(string: "\(Configuration.BASE_URL)")
        let bodyString = "api_token=\(Configuration.API_TOKEN)&device_type=\(Configuration.DEVICE_TYPE)"
        
        URLSessionManager.share.postRequest(with: url!, body: bodyString) { (data, error) in
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data! as Data)
                    completionHandler(response, error)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
