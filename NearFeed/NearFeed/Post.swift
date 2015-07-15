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
    @NSManaged var images: [PFFile]
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
    
    static func findByRegion(region: Region, list: (posts: [Post])->()){
        if let query = Post.query(){
            query.whereKey("region", equalTo: region)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
//    static func findAll(list: (posts: [Post])->()){
//        if let query = Post.query(){
//            if let posts = query.findObjects() as? [Post]{
//                list(posts: posts)
//            }
//        }
//    }
   
    func newPost(text: String, images: [UIImage]?, error: (error: NSError?)->()){
        self.text = text
        self.clicked = 0
        self.visualizations = 0
        if let imgs = images{
            self.images = [PFFile]()
            for img in imgs{
                self.images.append(PFFile(data: UIImagePNGRepresentation(img)))
            }
        }
        if let user = PFUser.currentUser(){
            self.user = user
        }
        self.region = UserLocation.location.region
        self.saveInBackgroundWithBlock { (success, erro) -> Void in
            if erro == nil {
                println("save post")
            }else{
                error(error: erro)
                println("not save post")
            }
        }
    }

}
