//
//  DriverdetailsViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 31/08/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import MapKit
import Firebase
class ColorPointAnnotation: MKPointAnnotation {
    
    var color: UIColor!
}
class DriverdetailsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,carhandlerdelegate{

    
    private var locationmaneger = CLLocationManager();
    private var userlocation : CLLocationCoordinate2D?
    private var riderlocation : CLLocationCoordinate2D?

    private var timer = Timer()
    private var acceptedCar = false;
    private var drivercanclerequest = false;
    @IBOutlet weak var mymapview: MKMapView!
    
    @IBOutlet weak var canclebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       initializelocationmanegar()
        Carhandler.Instance.delegate = self;
        mymapview.delegate = self
         mymapview.showsUserLocation = true
        Carhandler.Instance.observemessagesfordriver();
        
    }

    private func initializelocationmanegar() {
        locationmaneger.delegate = self;
        locationmaneger.desiredAccuracy = kCLLocationAccuracyBest
        locationmaneger.requestWhenInUseAuthorization();
        locationmaneger.startUpdatingLocation()
         }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("delegate calling")
        if let location = locationmaneger.location?.coordinate {


            userlocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region  = MKCoordinateRegion(center: userlocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            print(" user location \(String(describing: userlocation))")
            
            mymapview.setRegion(region, animated: true)
            mymapview.removeAnnotations(mymapview.annotations)
            if riderlocation != nil{
                if acceptedCar{
                    let riderannotation = MKPointAnnotation();
                    riderannotation.coordinate = riderlocation!;
                    riderannotation.title = "Rider  Location"
                    mymapview.addAnnotation(riderannotation)
                }
                
            }

             let annotation = ColorPointAnnotation()
//            let annotation = MKPointAnnotation();
            
            annotation.coordinate = userlocation!;
         
            annotation.title = "My location"
          
            mymapview.addAnnotation(annotation)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func carRequest(title : String ,message : String,requestAlive : Bool){
        
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if requestAlive{
            
        alert.addAction(UIAlertAction(title: "Accept", style: .default) { action in
            self.acceptedCar = true
            self.canclebtn.isHidden = false
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector:#selector(DriverdetailsViewController.updateDriverLocation), userInfo: nil, repeats: true)
            Carhandler.Instance.acceptrideRequest(latitutude: Double(self.userlocation!.latitude), longitude: Double(self.userlocation!.longitude))

        })
        
        alert.addAction(UIAlertAction(title: "Cancle", style: .default) { action in
            
            
        })
        }
        
        else{
            
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                
                
            })
            

        }
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func mapviewaction(_ sender: Any) {
        switch ((sender as AnyObject).selectedSegmentIndex) {
        case 0:
            mymapview.mapType = .standard
        case 1:
            mymapview.mapType = .hybrid
        default:
            mymapview.mapType = .satelliteFlyover
        }

    }
    
    @IBAction func callforRide(_ sender: Any) {
        if acceptedCar{
            drivercanclerequest = true
            self.canclebtn.isHidden = true;
            Carhandler.Instance.drivercancledride()
            timer.invalidate()
        }
        
    }
    @IBAction func logoutAction(_ sender: Any) {
        
        try! Auth.auth().signOut()
        if acceptedCar{
            self.canclebtn.isHidden = true;
            Carhandler.Instance.drivercancledride()
            timer.invalidate()
        }

        dismiss(animated: true, completion: nil)
    }
// car handler dedelegate
    func acceptcarRequest(lat: Double, long: Double) {
        
        if !acceptedCar{
        carRequest(title: " Got new request ", message: " You have a  ride request   at this location  lat : \(lat) ,log \(long)", requestAlive: true)
        }
    }
 
    func ridercancledrequest() {
        if !drivercanclerequest{
            Carhandler.Instance.drivercancledride()
            self.acceptedCar = false
            self.canclebtn.isHidden = true
            carRequest(title: "Ride request Cancled ", message: "Rider has cancled the request", requestAlive: false)
        }
      
    }
    
    func drivercancled() {
        acceptedCar = false
        self.canclebtn.isHidden = true
        timer.invalidate();
    }
    
    func updateDriverLocation(){
        Carhandler.Instance.updateDriversLocation(lat: userlocation!.latitude, lan: userlocation!.longitude)
    }
    
  
    
    func updateRiderlocation(lat: Double, lang: Double) {
           riderlocation =  CLLocationCoordinate2D(latitude:lat , longitude: lang)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let pin = annotation as? ColorPointAnnotation {
            
            let identifier = "pinAnnotation"
            
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                
                view.pinTintColor = pin.color ?? .purple
                
                return view
                
            } else {
                
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                view.canShowCallout = true
                
                view.pinTintColor = pin.color ?? .purple
                
                return view
            }
        }
        
        return nil
    }
        
 }
