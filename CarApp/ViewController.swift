//
//  ViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 31/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var mainbackgroundImageview: UIImageView!
    
    @IBOutlet weak var welcomelable: UILabel!
    @IBOutlet weak var driverbuttonnew: UIButton!
    @IBOutlet weak var riderbuttonnew: UIButton!
  
    
    
    var imageArray : NSArray = ["car1","car2","car3","car4",];
    var titleArray : NSArray = ["Welcome to Instacar","High Quality Service","Easy to Use ","Fair Pricing System"]
    
    var currentindex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButtonUi()
       self.createUi()
        
    }

      func createUi()  {
        
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action:#selector(ViewController.respondToSwipeGesture(_:)) )
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        self.view .addGestureRecognizer(swipeGestureRight)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeGestureLeft)
        pagecontrol.numberOfPages = imageArray.count
        
        welcomelable.text = titleArray.object(at: 0) as? String
          mainbackgroundImageview.image = UIImage(named: (imageArray.object(at: 0) as? String)!)
    }
    
    func updateButtonUi(){
        
        riderbuttonnew.layer.borderWidth = 1;
        riderbuttonnew.layer.cornerRadius = 20;
        riderbuttonnew.layer.borderColor = UIColor.white.cgColor
        driverbuttonnew.layer.borderWidth = 1;
        driverbuttonnew.layer.cornerRadius = 20;
        driverbuttonnew.layer.borderColor = UIColor.white.cgColor
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
    
    func respondToSwipeGesture(_ sender: UIGestureRecognizer)  {
        
        if  let swipeGesture  =  sender as? UISwipeGestureRecognizer  {
            
            switch  swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("right swipe")
                rightswipeaction()
                
                
            case UISwipeGestureRecognizerDirection.left:
                print("leftSwipe")
              leftswipeaction()
                
            default:
                break
            }
            
            
            
        }
        
        
    }
    
    func rightswipeaction(){
        currentindex = currentindex+1;
        if   currentindex >= imageArray.count
        {
            currentindex = imageArray.count-1;
            pagecontrol.currentPage = currentindex
          return
        }
        else {
            pagecontrol.currentPage = currentindex
                welcomelable.text = titleArray.object(at: currentindex) as? String
               mainbackgroundImageview.image = UIImage(named: (imageArray.object(at: currentindex) as? String)!)
        }

        
        
        
    }
    
    func leftswipeaction(){
       
        currentindex = currentindex-1;

        if   currentindex < 0
        {
            currentindex = 0
            pagecontrol.currentPage = currentindex

            return
        }
        else {
            pagecontrol.currentPage = currentindex
            welcomelable.text = titleArray.object(at: currentindex) as? String
            mainbackgroundImageview.image = UIImage(named: (imageArray.object(at: currentindex) as? String)!)
        }

        
    }
    
    
    
    @IBAction func driverbuttonclickAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "DriverViewController") as! DriverViewController
                self.present(newViewController, animated: true, completion: nil)

        
   
        
    }
    
    @IBAction func riderbuttonclickaction(_ sender: Any) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "RiderViewController") as! RiderViewController
                self.present(newViewController, animated: true, completion: nil)
        }
 }

