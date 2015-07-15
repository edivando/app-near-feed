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
    
    var country = Country()
    var city = City()
    var region = Region()
    
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
                    if let pm:CLPlacemark = placemarks[0] as? CLPlacemark{
                        
                        //Save country if not Existe in server
                        if let ct = pm.country{
                            self.country.name = ct
                            self.country.findByName({ (countrys) -> () in
                                if countrys.count == 0 {
                                    self.country.saveInBackground()
                                }else{
                                    self.country = countrys[0]
                                }
                                
                                //Save city if not existe in server
                                if let ct = pm.locality{
                                    self.city.name = pm.locality
                                    self.city.country = self.country
                                    self.city.findByName({ (citys) -> () in
                                        if citys.count == 0 {
                                            self.city.saveInBackground()
                                        }else{
                                            self.city = citys[0]
                                        }
                                        
                                        //Save region if not existe in server
                                        if let rg = pm.subLocality{
                                            self.region.name = pm.subLocality
                                            self.region.city = self.city
                                            self.region.findByName({ (regions) -> () in
                                                if regions.count == 0 {
                                                    self.region.saveInBackground()
                                                }else{
                                                    self.region = regions[0]
                                                }
                                                }, error: { (erro) -> () in
                                            })
                                        }
                                        
                                        
                                    }, error: { (erro) -> () in
                                    })
                                }
                            }, error: { (erro) -> () in
                            })
                        }
                    }
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
