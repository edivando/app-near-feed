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
    
    @NSManaged var region: Region?
    @NSManaged var city: City?
    @NSManaged var country: Country?
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    static let paginationLenght = 25
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    private static var crtUser = User.currentUser()
    
    static func current() -> User?{
        return crtUser
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
    
    static func findAllOrderByScores(page: Int, callback: (users: [User]?) ->()){
        let query = User.query()
        query?.orderByDescending("score")
        query?.skip = page * User.paginationLenght
        query?.limit = paginationLenght
        query?.whereKeyExists("name")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil{
                callback(users: objects as? [User])
            }else{
                callback(users: nil)
            }
        })
    }
    
    static func findFirstUserByScore(callback: (user: User?) ->()){
        let query = User.query()
        query?.orderByDescending("score")
        query?.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
            if error == nil{
                callback(user: object as? User)
            }else{
                callback(user: nil)
            }
        })
    }
}




