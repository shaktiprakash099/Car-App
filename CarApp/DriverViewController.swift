//
//  DriverViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 31/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseAuth
class DriverViewController: UIViewController {

    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbuttonaction(_ sender: Any) {
        self.dismiss(animated:true , completion: nil)
    }

    @IBAction func loginbuttonaction(_ sender: Any) {
        passwordtextfield.resignFirstResponder()
        if emailtextfield.text != "" && passwordtextfield.text  != ""{
            Auth.auth().signIn(withEmail: emailtextfield.text!, password: passwordtextfield.text!, completion: { (user, Error) in
                
                if Error != nil{
                    print("we have an error \(String(describing: Error  ))")
                    let  errormessage = Error?.localizedDescription
                                     let alert =  UIAlertController(title: "Authentication problem", message: errormessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                        })
                    self.present(alert, animated: true, completion: nil)
                                 }
                else{
                    print("we are logged in");
                    
                    Carhandler.Instance.driver = self.emailtextfield.text!
                    self.emailtextfield.text = ""
                    self.passwordtextfield.text = ""
                    self.performSegue(withIdentifier: "showmaproutefordriver", sender: nil)
                }
            })
        
        }
        else{
            let alert =  UIAlertController(title: "Authentication problem", message: "Email and password are required ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
            })
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func signupbuttonaction(_ sender: Any) {
        if emailtextfield.text != "" && passwordtextfield.text  != ""{
            Auth.auth().createUser(withEmail: emailtextfield.text!, password: passwordtextfield.text!, completion: { (user, Error) in
                
                if Error != nil{
                    print("we have an error \(String(describing: Error  ))")
                    let  errormessage = Error?.localizedDescription
                    let alert =  UIAlertController(title: "Problem with creating new user", message: errormessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                    })
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    if user?.uid != nil{
                        
                        Authprovider.Shareinstance.savedriverinfo(withId: user! .uid, email: self.emailtextfield.text!, password: self.passwordtextfield.text!
                        )
                        self.emailtextfield.text = ""
                        self.passwordtextfield.text = ""
                        let alert =  UIAlertController(title: "Success", message: " You have successfully registred", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        else{
            let alert =  UIAlertController(title: "Authentication problem", message: "Email and password are required ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
            })
            self.present(alert, animated: true, completion: nil)
            
        }

        
        
        
    }
    

}
