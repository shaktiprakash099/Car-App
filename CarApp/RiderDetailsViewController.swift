//
//  RiderDetailsViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 31/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
@available(iOS 10.0, *)
class RiderDetailsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,carhandlerdelegate,UISearchBarDelegate {

    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    
    
    @IBOutlet weak var callcarBtn: UIButton!
    @IBOutlet weak var mymapview: MKMapView!
    
    private var locationmaneger = CLLocationManager();
    private var userlocation : CLLocationCoordinate2D?
    private var destinationlocation : CLLocationCoordinate2D?
    private var driverlocation : CLLocationCoordinate2D?
    var desinationlattitude : Double?
    var destnationlongitude : Double?
    
    private var timer = Timer()
    private var canCalladriver = true;
    private var ridercanclerequest = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializelocationmanegar()
        Carhandler.Instance.delegate = self;
          mymapview.delegate = self
          mymapview.showsUserLocation = true
         mymapview.showsPointsOfInterest = true
        mymapview.showsScale = true
        mymapview.showsTraffic = true
        mymapview.showsBuildings = true
        Carhandler.Instance.observemessagesforRider()
//        loaddirection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializelocationmanegar() {
        locationmaneger.delegate = self;
        locationmaneger.desiredAccuracy = kCLLocationAccuracyBest
        locationmaneger.requestWhenInUseAuthorization();
        locationmaneger.startUpdatingLocation()
    }
    //mapview delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("delegate calling")
        if let location = locationmaneger.location?.coordinate {
            //            locationmaneger.stopUpdatingLocation()
            
            userlocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region  = MKCoordinateRegion(center: userlocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            print(" user location \(String(describing: userlocation))")
            
            mymapview.setRegion(region, animated: true)
            mymapview.removeAnnotations(mymapview.annotations)
//            if self.desinationlattitude != nil{
//            self.loaddirection(lat: desinationlattitude!, long: destnationlongitude!)
//            }
       
            print("inside riderlocation")
            if driverlocation != nil{
                print("inside riderlocation2")

                if !canCalladriver{
                        print("inside riderlocation3")
                    let driverannotation = MKPointAnnotation();
                    driverannotation.coordinate = driverlocation!;
                    driverannotation.title = "Drivers Location"
                    mymapview.addAnnotation(driverannotation)
//                     self.loaddirection(lat: 12.2313213, long: 12.45343543)
                }
            
            }
//            let annotation = MKPointAnnotation();
            let annotation = ColorPointAnnotation()
            annotation.coordinate = userlocation!;
            annotation.title = "My Location"
            mymapview.addAnnotation(annotation)
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mymapview.add(polyline)
        }
    }
    @IBAction func segmenaction(_ sender: Any) {
        switch ((sender as AnyObject).selectedSegmentIndex) {
        case 0:
            mymapview.mapType = .standard
        case 1:
            mymapview.mapType = .hybrid
        default:
            mymapview.mapType = .satelliteFlyover
        }
           
    }
    @IBAction func logoutActionforrider(_ sender: Any) {
        try! Auth.auth().signOut()
        if  !canCalladriver{
            Carhandler.Instance.cancleride()
            timer.invalidate()
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func requestforarideaction(_ sender: Any) {
        
        if userlocation != nil{
            if canCalladriver {
                
                Carhandler.Instance.requestforRide(latitude: Double(userlocation!.latitude), logitude: Double(userlocation!.longitude))
                   timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector:#selector(RiderDetailsViewController.updateriderlocations), userInfo: nil, repeats: true)
                
            }
        
        else{
            ridercanclerequest = true;
            Carhandler.Instance.cancleride()
            timer.invalidate()
        }
        }
    }
    //  delegate methods
    func cancallCar(delegateCalled: Bool) {
        
        if delegateCalled{
            callcarBtn.setTitle("Cancle Ride", for: UIControlState.normal)
            canCalladriver = false;
        }
        else{
            callcarBtn.setTitle("Request for Ride", for: UIControlState.normal)
            canCalladriver = true;

        }
    }
   
    func driverAccepted(requestaccepted: Bool, drivername: String) {
        if !ridercanclerequest{
            if requestaccepted{
            alerttherider(title: "Car request accepted", message: "\(drivername) accepted your request")
            }
            else{
                Carhandler.Instance.cancleride()
                timer.invalidate()
                alerttherider(title: "Request cancled", message: "\(drivername)cancled your   request")  
            }
        }
        ridercanclerequest = false;
    }
    
    private func alerttherider(title : String ,message : String){
        
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                       })
            
        self.present(alert, animated: true, completion: nil)
        
        
    }

    
    
    func updateriderlocations(){
        Carhandler.Instance.updateRidersLocation(lat: userlocation!.latitude, lan: userlocation!.longitude)
    }
    

    
    func updatedriverlocation(lat: Double, lang: Double) {
        
          driverlocation =  CLLocationCoordinate2D(latitude:lat , longitude: lang)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let pin = annotation as? ColorPointAnnotation {
            
            let identifier = "pinAnnotation"
            
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                
                view.pinTintColor = pin.color ?? .blue
                
                return view
                
            } else {
                
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                view.canShowCallout = true
                
                view.pinTintColor = pin.color ?? .blue
                
                return view
            }
        }
        
        return nil
    }

    @IBAction func chooseroureaction(_ sender: Any) {
      
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self as? UISearchBarDelegate
        present(searchController, animated: true, completion: nil)
        
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mymapview.annotations.count != 0{
            annotation = self.mymapview.annotations[0]
            self.mymapview.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
         
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mymapview.centerCoordinate = self.pointAnnotation.coordinate
            self.mymapview.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

    
    @available(iOS 10.0, *)
    func loaddirection(lat: Double,long : Double){
        print("direction loading")
        
//        let sourceCoodinate =  userlocation!
//        let destnationcoorinate = CLLocationCoordinate2DMake(lat, long)
//
//            let sourceplacemark = MKPlacemark(coordinate: sourceCoodinate)
//                 let destinationplacemark = MKPlacemark(coordinate: destnationcoorinate)
//       
//        
//        let sourceitem = MKMapItem(placemark: sourceplacemark)
//        let destinyitem = MKMapItem(placemark: destinationplacemark)
//        
//        let request = MKDirectionsRequest()
//        request.source = sourceitem
//        request.destination = destinyitem
//        request.requestsAlternateRoutes = false
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculate(completionHandler: {(response, error) in
//            
//            if error != nil {
//                print("Error getting directions\(error!)")
//            } else {
//               
//                let route =  response?.routes[0]
//                let rect = route?.polyline.boundingMapRect
//              
//                DispatchQueue.main.async {
//                      self.mymapview.add((route?.polyline)!,level: .aboveRoads)
//                    self.mymapview.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
//               }
//
//                
//            }
//        })
        let locations = [CLLocation(latitude: (userlocation?.latitude)!, longitude: (userlocation?.longitude)!), CLLocation(latitude: lat,longitude: long) ]
        let coordinates = locations.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
//        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        
        let geodesic = MKGeodesicPolyline(coordinates: coordinates, count: locations.count)
        DispatchQueue.main.async {
        
            self.mymapview.add(geodesic,level: MKOverlayLevel.aboveRoads)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("mkoverlaycalled")
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
         renderer.lineWidth = 4.0
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    @IBAction func showgooglemap(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "showinGooglemapsViewController") as! showinGooglemapsViewController
//        self.present(newViewController, animated: true, completion: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainnavigationViewController") as! mainnavigationViewController
                self.present(newViewController, animated: true, completion: nil)

    }
   

}
