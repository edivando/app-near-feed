//
//  UserPlace.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import CoreLocation
import Parse

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var user = User.current()

    private var locationStatus = true
    
    static var countryName = "Brasil"
    static var countryCode = "BR"
    static var cityName    = "Fortaleza"
    static var regionName  = "Benfica"
    
    var successCallback: (success: Bool)->() = {success in}
    
    init(callback: (success: Bool)->()){
        super.init()
        self.successCallback = callback
        if let user = user{
            if locationManager.location != nil{
                user.latitude = locationManager.location.coordinate.latitude
                user.longitude = locationManager.location.coordinate.longitude
                user.saveInBackground()
            }
            
            //Get country or set default country
            if let country = user.country{
                user.objectForKey("country")?.fetchIfNeeded()
            }else{
                saveUserLocationCountry(user)
            }
            
            //Get city or set default city
            if let city = user.city{
                user.objectForKey("city")?.fetchIfNeeded()
            }else{
                saveUserLocationCity(user)
            }
            
            //Get region or set default region
            if let region = user.region{
                user.objectForKey("region")?.fetchIfNeeded()
            }else{
                saveUserLocationRegion(user)
            }
        }
        getGeocoder()
    }
    
    func getGeocoder(){
        startLocation(true)
        if locationManager.location != nil{
            CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    println("Geocoder error: " + error.localizedDescription)
                    self.successCallback(success: false)
                } else if placemarks.count > 0, let pm:CLPlacemark = placemarks[0] as? CLPlacemark{
                    if let country = pm.country, let code = pm.ISOcountryCode{
                        UserLocation.countryName = country
                        UserLocation.countryCode = code
                    }
                    if let locality = pm.locality{
                        UserLocation.cityName = pm.locality
                    }
                    if let sublocality = pm.subLocality{
                        UserLocation.regionName = sublocality
                    }
                    self.successCallback(success: true)
                } else {
                    self.successCallback(success: false)
                    println("Problem with the data received from geocoder")
                }
                self.startLocation(false)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateLocation()
                })
            })
        }
    }
    
    func updateLocation(){
        if let user = user{
            if let country = user.country where country.name != UserLocation.countryName{
                Country.findByName(UserLocation.countryName, success: { (country) -> () in
                    if let country = country{
                        user.country = country
                        user.saveInBackground()
                        self.updateLocationCity()
                    }else{
                        let country = Country()
                        country.name = UserLocation.countryName
                        country.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                user.country = country
                                user.saveInBackground()
                            }
                            self.updateLocationCity()
                        })
                    }
                })
            }else{
                self.updateLocationCity()
            }
        }
    }
    
    private func updateLocationCity(){
        if let user = user{
            if let city = user.city where city.name != UserLocation.cityName{
                City.findByName(UserLocation.cityName, success: { (city) -> () in
                    if let city = city{
                        user.city = city
                        user.saveInBackground()
                        self.updateLocationRegion()
                    }else if let country = user.country{
                        let city = City()
                        city.name = UserLocation.cityName
                        city.country = country
                        city.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                user.city = city
                                user.saveInBackground()
                            }
                            self.updateLocationRegion()
                        })
                    }
                })
            }else{
                self.updateLocationRegion()
            }
        }
    }
    
    private func updateLocationRegion(){
        if let user = user{
            if let region = user.region where region.name != UserLocation.regionName{
                Region.findByName(UserLocation.regionName, success: { (region) -> () in
                    if let region = region{
                        user.region = region
                        user.saveInBackground()
                    }else if let city = user.city{
                        let region = Region()
                        region.name = UserLocation.regionName
                        region.city = city
                        region.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success {
                                user.region = region
                                user.saveInBackground()
                            }
                        })
                    }
                })
            }
        }
    }
    
    private func saveUserLocationCountry(user: User){
        Country.findByName(UserLocation.countryName, success: { (country) -> () in
            if let country = country{
                user.country = country
                user.saveInBackground()
            }
        })
    }
    
    private func saveUserLocationCity(user: User){
        City.findByName(UserLocation.cityName, success: { (city) -> () in
            if let city = city{
                user.city = city
                user.saveInBackground()
            }
        })
    }
    
    private func saveUserLocationRegion(user: User){
        Region.findByName(UserLocation.regionName, success: { (region) -> () in
            if let region = region{
                user.region = region
                user.saveInBackground()
            }
        })
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
