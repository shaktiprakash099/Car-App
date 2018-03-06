//
//  ChatViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 15/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import MobileCoreServices
import JSQMessagesViewController
import AVKit
import SDWebImage
class ChatViewController: JSQMessagesViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MessagehandlerDelegate{

    
    
    var senderuid:String!
    var senderEmail : String!
    private var messages = [JSQMessage]();
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        Messagehandler.Instance.delegate = self
        Messagehandler.Instance.observemessages()
        Messagehandler.Instance.observemediamessages()
        self.senderId = self.senderuid
        self.senderDisplayName = self.senderEmail
        
      
    }
// collection view function
   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let  message = messages[indexPath.item]
        if message.senderId == self.senderId{
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "mypic"), diameter: 30)
        }
        else{
              return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "p"), diameter: 30)
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubblefactry = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == self.senderId{
        return bubblefactry?.outgoingMessagesBubbleImage(with: UIColor.cyan)
        }
        else{
             return bubblefactry?.incomingMessagesBubbleImage(with: UIColor.green)
        }
    }
    
  
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = messages[indexPath.item]
        
        if msg.isMediaMessage{
            
            if let  mediaItem = msg.media as? JSQVideoMediaItem {
                
                let player = AVPlayer(url: mediaItem.fileURL)
                let playercontroller = AVPlayerViewController()
                playercontroller.player = player
                self.present(playercontroller, animated: true, completion: nil)
            }
        }
    }
    
    
    // for displaying user name
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    // send button action
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        Messagehandler.Instance.sendmessages(senderId: senderId, senderName: senderDisplayName, text: text)
        
//        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
//        collectionView.reloadData()
        finishSendingMessage(animated:true)
        scrollToBottom(animated: true)
    }
    // send media action
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Please select A media", message: " ", preferredStyle: .actionSheet);
        let cancle = UIAlertAction(title: "Cancle", style: .cancel, handler: nil);
        let photos = UIAlertAction(title: "Photos", style: .default) { (alert: UIAlertAction) in
            self.choosemedia(type: kUTTypeImage)
        }
        let video = UIAlertAction(title: "Videos", style: .default) { (alert: UIAlertAction) in
             self.choosemedia(type: kUTTypeMovie)
        }
        alert.addAction(cancle)
        alert.addAction(photos)
        alert.addAction(video)
        present(alert, animated: true, completion: nil)
        
        
    }
    private func choosemedia(type : CFString){
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
        
    }
    // image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let data = UIImageJPEGRepresentation(pic, 0.01)
            Messagehandler.Instance.sendMedia(image: data!, video: nil, senderId: senderId, senderName: senderDisplayName)
//            let image = JSQPhotoMediaItem(image: pic)
//            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: image))
        }
        else if let videourl = info[UIImagePickerControllerMediaURL] as? URL{
            
               Messagehandler.Instance.sendMedia(image: nil , video: videourl, senderId: senderId, senderName: senderDisplayName)
//            let video = JSQVideoMediaItem(fileURL : videourl ,isReadyToPlay : true);
//            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
        }
    
        
        self.dismiss(animated: true, completion: nil)
         collectionView.reloadData()
    }
    // picker view function
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    // delegate function
    
    func messagereceivedfromfirebase(senderId: String, sendername: String, text: String) {
        
         self.messages.append(JSQMessage(senderId: senderId, displayName: sendername, text: text))
          finishReceivingMessage()
         finishReceivingMessage(animated: true)
          collectionView.reloadData()
    }

    func mediareceivedfromfirebase(senderId: String, sendername: String, url: String) {
        
        if let mediaUrl =  URL(string: url){
            do {
                let data = try Data(contentsOf : mediaUrl)
                if let  _ = UIImage(data: data){
                    
                    let  _  = SDWebImageDownloader.shared().downloadImage(with: mediaUrl, options: [], progress: nil, completed: {(image,data,error,finished) in
                        
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image)
                            
                            if senderId == self.senderId{
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            }
                            
                            else{
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            
                           self.messages.append(JSQMessage(senderId: senderId, displayName: sendername, media: photo))
                           self.collectionView.reloadData()
                        }
                })
                }
                
                else{
                    let video = JSQVideoMediaItem(fileURL: mediaUrl, isReadyToPlay: true)
                    if senderId == self.senderId{
                        video?.appliesMediaViewMaskAsOutgoing = true
                    }
                        
                    else{
                        video?.appliesMediaViewMaskAsOutgoing = false
                    }

                    self.messages.append(JSQMessage(senderId: senderId, displayName: sendername, media: video))
                    self.collectionView.reloadData()
                    
                    
                    
                }
                
            } catch  {
                
                
                
            }
        }
    }
}
