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
        return "PostComment"
    }
    
    static func findCommentsByPost(post: Post, list: (comments: [PostComment]) -> ()){
        if let query = PostComment.query(){
            query.whereKey("post", equalTo: post)
            query.orderByAscending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let comments = objects as? [PostComment]{
                    list(comments: comments)
                }
            })
        }
    }
    
    func addComment(post: Post, message: String){
        self.message = message
        self.post = post
        if let user = PFUser.currentUser(){
            self.user = user
        }
        self.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("save post comment")
            }else{
                println("not save post comment")
            }
        }
    }
}