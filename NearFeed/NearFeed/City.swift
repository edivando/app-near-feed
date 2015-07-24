//
//  City.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class City: PFObject, PFSubclassing {
   
    @NSManaged var name: String
    @NSManaged var country: Country
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "City"
    }
    
//MARK: Finds
    static func findByName(name: String, success: (citys: City?)->()){
        if let query = City.queryByName(name){
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if error == nil {
                    success(citys: (object as? City)!)
                } else {
                    success(citys: nil)
                    if let code = error?.code{
                        Message.error("Country", text: "\(code)")
                    }
                }
            })
        }
    }
    
    static func findAllByCountry(country: PFObject?, result: (cities: [City]?) -> ()){
        if let query = City.query(){
            if let country = country{
                query.whereKey("country", equalTo: country)
            }else if let obj = UserLocation.country.objectId{
                query.whereKey("country", equalTo: UserLocation.country)
            }else if let countryQuery = Country.queryByName(UserLocation.countryName){
                query.whereKey("country", matchesQuery: countryQuery)
            }
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil{
                    result(cities: objects as? [City])
                }
                else{
                    result(cities: nil)
                }
            })
        }
    }
    
    
//MARK: Querys
    static func queryByName(name: String) -> PFQuery?{
        if let query = City.query(){
            query.whereKey("name", equalTo: name)
            return query
        }
        return nil
    }
}