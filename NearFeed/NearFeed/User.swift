//
//  User.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/16/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class User: PFUser, PFSubclassing, CLLocationManagerDelegate {
   
    @NSManaged var name: String
    @NSManaged var blocked: String
    @NSManaged var image: PFFile
    @NSManaged var score: NSNumber
    
    
    @NSManaged var region: Region
    @NSManaged var city: City
    @NSManaged var country: Country
    
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    func updateScores(score: Score, callback: (success: Bool) ->()){
        self.score = self.score.integerValue + score.value
        saveInBackgroundWithBlock { (success, error) -> Void in
            callback(success: success)
        }
    }
    
    func updateScores(score: Score){
        self.score = self.score.integerValue + score.value
        saveInBackground()
    }
    
    static func findAllOrderByScores(callback: (users: [User]?) ->()){
        let query = User.query()
        query?.orderByDescending("score")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil{
                callback(users: objects as? [User])
            }else{
                callback(users: nil)
            }
        })
    }
}




