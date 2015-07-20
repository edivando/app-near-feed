//
//  Country.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//


import Parse

class Country: PFObject, PFSubclassing  {
    
    @NSManaged var name: String
   
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Country"
    }
    
    static func findByName(name: String, success: (countrys: Country?)->()){
        if let query = Country.query(){
            query.whereKey("name", equalTo: name)
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if error == nil {
                    success(countrys: (object as? Country)!)
                } else {
                    success(countrys: nil)
                    if let code = error?.code{
                        Message.error("Country", text: "\(code)")
                    }
                }
            })
        }
    }
    
}
