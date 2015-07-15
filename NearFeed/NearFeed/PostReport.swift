//
//  PostReport.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/14/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class PostReport: PFObject, PFSubclassing {
    
    @NSManaged var message: String
    @NSManaged var post: Post
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
        return "PostReport"
    }
    
    
    func addReport(post: Post, message: String){
        self.message = message
        self.post = post
        if let user = PFUser.currentUser(){
            self.user = user
        }
        self.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("save post report")
            }else{
                println("not save post report")
            }
        }
    }
}