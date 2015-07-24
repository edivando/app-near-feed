//
//  PostComment.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/14/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class PostComment: PFObject, PFSubclassing {
    
    @NSManaged var message: String
    @NSManaged var post: Post
    @NSManaged var user: User
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "PostComment"
    }
    

}