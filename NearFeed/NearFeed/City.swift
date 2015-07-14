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
    
    func findByName(success: (citys: [City])->(), error: (erro: NSError?)->()){
        if let query = City.query(){
            query.whereKey("name", equalTo: name)
            query.findObjectsInBackgroundWithBlock({ (objects, erro) -> Void in
                if erro == nil{
                    if let citys = objects as? [City]{
                        success(citys: citys)
                    }
                }else{
                    error(erro: erro)
                }
            })
        }
    }
    
}