//
//  User.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/18/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse
import UIKit

class User: PFUser, PFSubclassing, CLLocationManagerDelegate {
    
    @NSManaged var name: String
    @NSManaged var blocked: String
    @NSManaged var image: PFFile
    @NSManaged var score: NSNumber
    
    
    @NSManaged var region: Region
    @NSManaged var city: City
    @NSManaged var country: Country
    
    var imageProfile: UIImage?{
        get{
            if let imgData = image.getData(){
                return UIImage(data: imgData)
            }
            return UIImage(named: "user")
        }
    }
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}
