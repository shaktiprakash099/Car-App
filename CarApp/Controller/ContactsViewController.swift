//
//  ContactsViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 14/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,Dbproviderdelegate {

    @IBOutlet weak var mytableview: UITableView!
    var contactdetailsArray : NSArray!
    private let cellID = "Cellid"
    private var contacts = [ContactModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
     DBProvider.Instance.delegate = self
     DBProvider.Instance.getUserdetails()

    }

    func datareceived(contactdetailsarray: NSArray) {
    
        self.contactdetailsArray = contactdetailsarray
        self.mytableview.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backbuttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.contactdetailsArray == nil{
            return 0
        }
        else{
            return self.contactdetailsArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = (self.contactdetailsArray.object(at: indexPath.row) as! NSDictionary ).object(forKey: "email") as! String
        return cell;
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatcontroller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatcontroller.senderuid = (self.contactdetailsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: Constants.USER_UID) as! String
        chatcontroller.senderEmail = (self.contactdetailsArray.object(at: indexPath.row) as! NSDictionary).object(forKey: Constants.EMAIL) as! String
        self.navigationController?.pushViewController(chatcontroller, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
   

}
