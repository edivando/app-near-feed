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
    
    private static var countryName = "Default_Country"
    private static var cityName    = "Default_City"
    private static var regionName  = "Default_Region"
    
    static var country = Country()
    static var city = City()
    static var region = Region()
    
    override init(){
        super.init()
        UserLocation.country.name = UserLocation.countryName
        UserLocation.city.name = UserLocation.cityName
        UserLocation.region.name = UserLocation.regionName
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            startLocation(true)
        }
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
                    self.updateCountryLocalityParse()
                }
                else {
                    println("Problem with the data received from geocoder")
                }
                self.startLocation(false)
            })
        }
    }
    
    private func updateCountryLocalityParse(){
        Country.findByName(UserLocation.countryName, success: { (countrys) -> () in
            if let countrys = countrys{
                if let firstCountry = countrys.first{
                    UserLocation.country = firstCountry
                    self.updateCityLocalityParse()
                }else{
                    self.saveCountry({ self.updateCityLocalityParse() })
                }
            }else{
                self.saveCountry({ self.updateCityLocalityParse() })
            }
        })
    }
    
    private func updateCityLocalityParse(){
        City.findByName(UserLocation.cityName, success: { (citys) -> () in
            if let citys = citys{
                if let firstCity = citys.first{
                    UserLocation.city = firstCity
                    self.updateRegionLocalityParse()
                }else{
                    self.saveCity({ self.updateRegionLocalityParse() })
                }
            }else{
                self.saveCity({ self.updateRegionLocalityParse() })
            }
        })
    }
    
    private func updateRegionLocalityParse(){
        Region.findByName(UserLocation.regionName, success: { (regions) -> () in
            if let regions = regions{
                if let firstRegion = regions.first{
                    UserLocation.region = firstRegion
                    self.updateUserLocalityParse()
                }else{
                    self.saveRegion({ self.updateUserLocalityParse() })
                }
            }else{
                self.saveRegion({ self.updateUserLocalityParse() })
            }
        })
    }
    
    private func updateUserLocalityParse(){
        if let user = User.currentUser(){
            user.country = UserLocation.country
            user.city =  UserLocation.city
            user.region = UserLocation.region
            user.saveInBackground()
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
    
//MARK: Save data in parse
    private func saveCountry(funcBack: ()->()){
        UserLocation.country.name = UserLocation.countryName
        UserLocation.country.saveInBackgroundWithBlock { (success, error) -> Void in
            funcBack()
        }
    }
    
    private func saveCity(funcBack: ()->()){
        UserLocation.city.name = UserLocation.cityName
        UserLocation.city.country = UserLocation.country
        UserLocation.city.saveInBackgroundWithBlock { (success, error) -> Void in
            funcBack()
        }
    }
    
    private func saveRegion(funcBack: ()->()){
        UserLocation.region.name = UserLocation.regionName
        UserLocation.region.city = UserLocation.city
        UserLocation.region.saveInBackgroundWithBlock { (success, error) -> Void in
            funcBack()
        }
    }

}
