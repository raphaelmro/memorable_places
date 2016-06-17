//
//  ViewController.swift
//  Memorable Places
//
//  Created by Raphael Onofre on 5/24/16.
//  Copyright © 2016 Raphael Onofre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var manager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else{
            let latitude = NSString(string: places[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["lon"]!).doubleValue
            
            var latDelta = 0.01
            var lonDelta = 0.01
            var span = MKCoordinateSpanMake(latDelta, lonDelta)
            var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            var region = MKCoordinateRegionMake(coordinate, span)
            
            self.map.setRegion(region, animated: true)

            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[activePlace]["name"]
            self.map.addAnnotation(annotation)

        }
        

        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(uilpgr)

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let userLatitude = userLocation.coordinate.latitude
        let userLongitude = userLocation.coordinate.longitude
        
        var latitude: CLLocationDegrees = userLatitude
        var longitude: CLLocationDegrees = userLongitude
        var latDelta = 0.05
        var lonDelta = 0.05
        var span = MKCoordinateSpanMake(latDelta, lonDelta)
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        var region = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
        
    }
    

    
    func action(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestureRecognizer.locationInView(self.map)
            var newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
           
            //ReverseGeoCoder Location
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                //place details
                var title = ""
                
                
                if(error == nil) {
                    if let p = (placemarks?[0]){
                        
                        var subThoroughFare: String = ""
                        var thoroughFare: String = ""
                        
                        if p.subThoroughfare != nil{
                            subThoroughFare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil{
                            thoroughFare = p.thoroughfare!
                        }
                        
                        title = "\(subThoroughFare) \(thoroughFare)"
                        
                        if title == ""{
                            title = "Added \(NSDate())"
                        }
                        
                        places.append(["name": title, "lat":"\(newCoordinate.latitude)", "lon":"\(newCoordinate.longitude)"])
                        
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = newCoordinate
                        annotation.title = title
                        self.map.addAnnotation(annotation)
                    }
                }
            })
            
        }
        
    }

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

