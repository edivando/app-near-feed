//
//  Post.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class Post: PFObject, PFSubclassing {
    
    @NSManaged var text: String
    @NSManaged var images: [UIImage]
    @NSManaged var clicked: NSNumber
    @NSManaged var visualizations: NSNumber
    @NSManaged var region: Region
    @NSManaged var user: PFUser

    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    func findAll(){
        if let query = Post.query(){
            if let posts = query.findObjects() as? [Post]{
                for post in posts{
                    println(post)
                }
            }
        }
    }
   
    func newPost(text: String, images: [UIImage]?, error: (error: NSError?)->()){
        self.text = text
        self.clicked = 0
        self.visualizations = 0
        if let images = images{
            self.images = images
        }
        if let user = PFUser.currentUser(){
            self.user = user
        }
        self.region = UserLocation.location.region
        self.saveInBackgroundWithBlock { (success, erro) -> Void in
            if erro != nil {
                println("save post")
            }else{
                error(error: erro)
                println("not save post")
            }
        }
    }

}
