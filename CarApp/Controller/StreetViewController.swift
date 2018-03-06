//
//  StreetViewController.swift
//  CarApp
//
//  Created by GLB-312-PC on 13/09/17.
//  Copyright © 2017 GLB-312-PC. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetViewController: UIViewController {
   
    var lattitude: Double!
    var logitude: Double!
      var googleMapsView:GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //
                    let panoView = GMSPanoramaView(frame: .zero)
                    self.view = panoView
                    // -33.732 ,150.312
                    panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: lattitude, longitude: logitude))
                    panoView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 1)
                    let position = CLLocationCoordinate2DMake(lattitude, logitude)
                    let marker = GMSMarker(position: position)
        
        
                    marker.panoramaView = panoView
                    
                    marker.map = self.googleMapsView

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
