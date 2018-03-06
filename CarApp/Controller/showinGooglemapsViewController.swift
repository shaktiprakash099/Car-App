//
//  showinGooglemapsViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 05/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class showinGooglemapsViewController: UIViewController,CLLocationManagerDelegate,UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate,GMSPanoramaViewDelegate{
  
    
    
   public func didFailAutocompleteWithError(_ error: Error) {
        
    }

    @IBOutlet weak var myview: UIView!
    var locationManager = CLLocationManager()
   var searchResultController:SearchResultsController!
    var resultsArray = [String]()
    var googleMapsView:GMSMapView!
     var gmsFetcher: GMSAutocompleteFetcher!
//       let marker = GMSMarker()
    
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
//    
//        let panoView = GMSPanoramaView(frame: .zero)
//        self.view = panoView
//        // -33.732 ,150.312
//        panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: -33.732, longitude: 150.312))
//        panoView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 1)
//        let position = CLLocationCoordinate2DMake(-33.732, 150.312)
//        let marker = GMSMarker(position: position)
//
//        
//        marker.panoramaView = panoView
//     
//        marker.map = self.googleMapsView
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.googleMapsView =  GMSMapView(frame: self.myview.frame)
         self.googleMapsView.settings.myLocationButton = true;
        self.googleMapsView.isMyLocationEnabled = true
        self.view.addSubview(self.googleMapsView)
        searchResultController = SearchResultsController()
        
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }

    @IBAction func searchbuttonaction(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
//        searchResultController = SearchResultsController()
//        searchResultController.delegate = self
        self.present(searchController, animated: true, completion: nil)
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
       self.currentlocation()
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func currentlocation(){
        
      let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 14)
      let mapview = GMSMapView.map(withFrame:self.myview.bounds , camera: camera)
        mapview.settings.myLocationButton = true;
        mapview.isMyLocationEnabled = true
       let marker = GMSMarker()
       marker.position = camera.target
        marker.map = mapview
    self.myview.addSubview(mapview)
        
    }
    @IBAction func backaction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async() { () -> Void in
//            let position = CLLocationCoordinate2DMake(lat, lon)
//            let marker = GMSMarker(position: position)
//            
////            let camera  = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
////            self.googleMapsView.camera = camera
//            let panoView = GMSPanoramaView(frame: .zero)
//            self.myview = panoView
//            panoView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 1)
//            panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: 37.3317134, longitude: -122.0307466))
//        
//            marker.panoramaView = panoView
//            marker.title = "Address : \(title)"
//            marker.map = self.googleMapsView
            
            
            
            let panoView = GMSPanoramaView(frame: .zero)
            self.myview = panoView
            // -33.732 ,150.312
            panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            panoView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 1)
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            
            marker.panoramaView = panoView
            
            marker.map = self.googleMapsView
            
        
        }
    }
        func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
//        let placesClient = GMSPlacesClient()
//        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil, callback: { (results, error) -> Void in
//            self.resultsArray.removeAll()
//            if results == nil {
//                return
//            }
//            for result in results!{
//                if let result = result as? GMSAutocompletePrediction{
//                    self.resultsArray.append(result.attributedFullText.string)
//                }
//            }
//            self.searchResultController.reloadDataWithArray(array: self.resultsArray)
//        })
            self.resultsArray.removeAll()
            gmsFetcher?.sourceTextHasChanged(searchText)
          }
}
