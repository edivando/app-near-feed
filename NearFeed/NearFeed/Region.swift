//
//  Region.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class Region: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var city: City
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Region"
    }
    
    static func findByName(name: String, success: (region: Region?)->()){
        if let query = Region.queryByName(name){
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if error == nil {
                    success(region: (object as? Region)!)
                } else {
                    success(region: nil)
                    if let code = error?.code{
                        Message.error("Country", text: "\(code)")
                    }
                }
            })
        }
    }
    
    static func findAllByCity(city: PFObject?, result: (regions: [Region]?) -> ()){
        if let query = Region.query(){
            if let city = city{
                query.whereKey("city", equalTo: city)
            }else if let obj = UserLocation.city.objectId{
                query.whereKey("city", equalTo: UserLocation.city)
            }else if let cityQuery = City.queryByName(UserLocation.cityName){
                query.whereKey("city", matchesQuery: cityQuery)
            }
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil{
                    result(regions: objects as? [Region])
                }
                else{
                    result(regions: nil)
                }
            })
        }
    }
    
    static func findAllRegionsInCity(city: PFObject, result: (regions: [Region]?) -> ()){
        if let query = Region.query(){
            query.whereKey("city", equalTo: city)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil{
                    result(regions: objects as? [Region])
                }
                else{
                    result(regions: nil)
                }
            })
        }
    }
    
//MARK: Querys
    static func queryByName(name: String) -> PFQuery?{
        if let query = Region.query(){
            query.whereKey("name", equalTo: name)
            return query
        }
        return nil
    }
}
