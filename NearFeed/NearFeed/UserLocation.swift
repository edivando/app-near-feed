//
//  UserPlace.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import CoreLocation

private let _UserLocation = UserLocation()

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    static var location : UserLocation {
        return _UserLocation
    }
    
    let locationManager = CLLocationManager()
    
    var country: String?
    var city: String?
    var region: String?
    
    private var locationStatus = true
    
    
    private override init(){
        super.init()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            startLocation(true)
        }
    }
    
    func get() -> UserLocation{
        startLocation(true)
        if locationManager.location != nil{
            CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }else if placemarks.count > 0 {
                    let pm:CLPlacemark = placemarks[0] as! CLPlacemark
                    self.country = pm.country
                    self.city = pm.locality
                    self.region = pm.subLocality
                }
                else {
                    println("Problem with the data received from geocoder")
                }
                self.startLocation(false)
            })
        }
        return self
    }
    
    private func startLocation(status: Bool){
        if status {
            if locationStatus {
                locationManager.startUpdatingLocation()
                locationStatus = true
            }
        }else{
            if !locationStatus {
                locationManager.stopUpdatingLocation()
                locationStatus = false
            }
        }
        
    }

}
