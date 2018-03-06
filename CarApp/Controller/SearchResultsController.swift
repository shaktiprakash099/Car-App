//
//  SearchResultsController.swift
//  CarApp
//
//  Created by GLB-312-PC on 11/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit

protocol LocateOnTheMap{
    func locateWithLongitude(lon:Double, andLatitude lat:Double, andTitle title: String)
}
class SearchResultsController: UITableViewController {
    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print("serchresult count \(searchResults.count)")
        return self.searchResults.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell

      }
    
    
    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        let correctedAdderess: String! = self.searchResults[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
          let servisehelperclass = ServiseHelperclass();
        servisehelperclass.getdestinationaddress(name: correctedAdderess as String as NSString, callback: { (response) in
            print(response!)
            if let responseDict : NSDictionary = response as? NSDictionary{
                
                if  let  resultArray:NSArray = responseDict.object(forKey: "results") as? NSArray{
                    if resultArray.count>0{
                        let resultDict:NSDictionary = resultArray.object(at: 0) as! NSDictionary
                        if  let  geometryDict:NSDictionary = resultDict.object(forKey: "geometry") as? NSDictionary{
                            if  let  locationDict:NSDictionary = geometryDict.object(forKey: "location") as? NSDictionary{
                                
                                let destinationlat = locationDict.object(forKey: "lat") as? Double
                                print("lattitude \(destinationlat!)")
                                
                                let destinationlag = locationDict.object(forKey: "lng") as? Double
                                
                                print("longitude \(destinationlag!)")
                                
                                 self.delegate.locateWithLongitude(lon: destinationlag!, andLatitude: destinationlat!, andTitle: self.searchResults[indexPath.row] )
                                
                            }
                            
                        }
                        
                    }
                }
            }

        })
        
        
        
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
