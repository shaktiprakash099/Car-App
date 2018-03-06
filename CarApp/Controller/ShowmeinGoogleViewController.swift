//
//  ShowmeinGoogleViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 13/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ShowmeinGoogleViewController: UIViewController,CLLocationManagerDelegate,UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate,GMSPanoramaViewDelegate {
 var searchResultController:SearchResultsController!
    
    var resultsArray = [String]()
    var googleMapsView:GMSMapView!
    var gmsFetcher: GMSAutocompleteFetcher!
    var lattitudeReference :Double!
    var longitudeReference: Double!
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

 
    @IBAction func showcontacts(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyBoard.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
       
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
    }
    
    @IBAction func searchControllAction(_ sender: Any) {
        self.lattitudeReference = nil
        self.longitudeReference = nil
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
    
        self.present(searchController, animated: true, completion: nil)
        
    }
    @IBAction func showmetheStreetviewAction(_ sender: Any) {
       
           if self.lattitudeReference !=  nil{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "StreetViewController") as! StreetViewController
            secondViewController.lattitude = lattitudeReference
            secondViewController.logitude = longitudeReference
             self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Location not detected", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
            })
          self.present(alert, animated: true, completion: nil)
        }
        
       
        
    }
    @IBAction func backtapped(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Controller deinitilised")
    }
    
    public func didFailAutocompleteWithError(_ error: Error) {
        
    }
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(array: self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.googleMapsView =  GMSMapView(frame: self.view.frame)
        self.googleMapsView.settings.myLocationButton = true;
        self.googleMapsView.isMyLocationEnabled = true
        self.view.addSubview(self.googleMapsView)
        searchResultController = SearchResultsController()
        
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
             self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async() { () -> Void in
                        let position = CLLocationCoordinate2DMake(lat, lon)
                        let marker = GMSMarker(position: position)
            
                        let camera  = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
                        self.googleMapsView.camera = camera
            
                        marker.title = "Address : \(title)"
                        marker.map = self.googleMapsView
            
                     self.lattitudeReference = lat
                    self.longitudeReference = lon
            
        }
    }


}
