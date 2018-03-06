//
//  Messagehandler.swift
//  CarApp
//
//  Created by GLB-312-PC on 15/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
protocol MessagehandlerDelegate : class {
    func messagereceivedfromfirebase(senderId : String ,sendername : String , text : String)
    func mediareceivedfromfirebase(senderId : String , sendername : String ,url : String )
}

extension MessagehandlerDelegate{
    func messagereceivedfromfirebase(senderId : String ,sendername : String , text : String){
        
    }
    
    func mediareceivedfromfirebase(senderId : String , sendername : String ,url : String ){
        
    }
}
class Messagehandler{
    private static let  _instance = Messagehandler()
    weak var delegate : MessagehandlerDelegate?
    private init(){
        
    }
    
    static var Instance: Messagehandler{
        return _instance
    }
    
    func sendmessages(senderId: String,senderName : String ,text : String){
        let data: Dictionary<String,Any> = [Constants.SENDER_ID: senderId,Constants.SENDER_NAME:senderName,Constants.TEXT:text];
        DBProvider.Instance.messagereference.childByAutoId().setValue(data);
        
    }
    
    func sendmediamessages(senderId: String,senderName : String ,url : String)  {
        let data : Dictionary<String ,Any> = [Constants.SENDER_ID: senderId,Constants.SENDER_NAME:senderName,Constants.URL: url]
        DBProvider.Instance.mediamessagesreference.childByAutoId().setValue(data);
        
        
    }
    
    
    func sendMedia(image : Data?, video : URL? ,senderId: String,senderName : String)  {
        if image != nil{
            
            DBProvider.Instance.imagestorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil){ (metadata, error) in
              
                if error != nil{
                    // inform user failed while upload
                    
                }
                else{
                    self.sendmediamessages(senderId: senderId, senderName: senderName, url:  String (describing: metadata!.downloadURL()!))
                }
                
            }
        }
        else {
            
            DBProvider.Instance.videostorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putFile(from: video!, metadata: nil){ (metadata, error) in
                
                if error != nil{
                    // inform user failed while upload
                    
                }
                else{
                    self.sendmediamessages(senderId: senderId, senderName: senderName, url:  String (describing: metadata!.downloadURL()!))
                }
                
            }

            
        }
     
    }
    
    func observemessages() {
        DBProvider.Instance.messagereference.observe(DataEventType.childAdded, with: {
            (DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                if let senderId = data[Constants.SENDER_ID] as? String{
                    if let senderName = data[Constants.SENDER_NAME] as? String{
                        if let text = data [Constants.TEXT] as? String{
                            self.delegate?.messagereceivedfromfirebase(senderId: senderId, sendername: senderName, text: text)
                        }
                    }
                }
            }
            
            
        })
    
    
    }
    
    func observemediamessages()  {
        DBProvider.Instance.mediamessagesreference.observe(DataEventType.childAdded, with: {(DataSnapshot) in
            
            if let data = DataSnapshot.value as? NSDictionary{
                if let senderid = data[Constants.SENDER_ID] as? String{
                    if let senderaname = data[Constants.SENDER_NAME] as? String{
                        
                        if let fileurl  = data[Constants.URL] as? String{
                            self.delegate?.mediareceivedfromfirebase(senderId: senderid, sendername: senderaname, url: fileurl)
                        }
                    }
                    
                    
                }
                
            }
        })
    }
}
