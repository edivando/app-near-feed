//
//  UserPlace.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import CoreLocation
import Parse

//var userCountry = Country()
//var userCity = City()
//var userRegion = Region()

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    private var locationStatus = true
    
    static var countryName = "Default_Country"
    static var cityName    = "Default_City"
    static var regionName  = "Default_Region"
    
    static var country = Country()
    static var city = City()
    static var region = Region()
    
    var successCallback: ()->() = {}
    
    init(successCallback: ()->()){
        super.init()
        self.successCallback = successCallback
        UserLocation.country.name = UserLocation.countryName
        UserLocation.city.name = UserLocation.cityName
        UserLocation.region.name = UserLocation.regionName
        getGeocoder()
    }
    
    func getGeocoder(){
        startLocation(true)
        if locationManager.location != nil{
            CLGeocoder().reverseGeocodeLocation(locationManager.location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    println("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }else if placemarks.count > 0, let pm:CLPlacemark = placemarks[0] as? CLPlacemark{
                    if let country = pm.country{
                        UserLocation.countryName = country
                    }
                    if let locality = pm.locality{
                        UserLocation.cityName = pm.locality
                    }
                    if let sublocality = pm.subLocality{
                        UserLocation.regionName = sublocality
                    }
                    self.successCallback()
//                    self.updateCountryLocalityParse()
                }
                else {
                    println("Problem with the data received from geocoder")
                }
                self.startLocation(false)
            })
        }
    }
    
    static func updateCountryLocalityParse(){
        if UserLocation.country.name != UserLocation.countryName || UserLocation.country.objectId == nil{
            Country.findByName(UserLocation.countryName, success: { (country) -> () in
                if let country = country{
                    UserLocation.country = country
                }else{
                    UserLocation.country.name = UserLocation.countryName
                }
                self.updateCityLocalityParse()
            })
        }else{
            self.updateCityLocalityParse()
        }
    }
    
    private static func updateCityLocalityParse(){
        if UserLocation.city.name != UserLocation.cityName || UserLocation.city.objectId == nil{
            City.findByName(UserLocation.cityName, success: { (city) -> () in
                if let city = city{
                    UserLocation.city = city
                }else{
                    UserLocation.city.name = UserLocation.cityName
                    UserLocation.city.country = UserLocation.country
                }
                self.updateRegionLocalityParse()
            })
        }else{
            self.updateRegionLocalityParse()
        }
    }
    
    private static func updateRegionLocalityParse(){
        if UserLocation.region.name != UserLocation.regionName || UserLocation.region.objectId == nil{
            Region.findByName(UserLocation.regionName, success: { (region) -> () in
                if let region = region{
                    UserLocation.region = region
                }else{
                    UserLocation.region.name = UserLocation.regionName
                    UserLocation.region.city = UserLocation.city
                }
                self.updateUserLocalityParse()
            })
        }else{
            self.updateUserLocalityParse()
        }
    }
    
    private static func updateUserLocalityParse(){
        if let user = User.currentUser() where (user.country != UserLocation.country || user.city != UserLocation.city || user.region != UserLocation.region){
            user.country = UserLocation.country
            user.city   = UserLocation.city
            user.region = UserLocation.region
            user.saveInBackground()
        }else{
            UserLocation.region.saveInBackground()
        }
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
