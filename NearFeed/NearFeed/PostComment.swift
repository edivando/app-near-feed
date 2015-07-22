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
    
//    static func findCommentsByPost(post: Post, list: (comments: [PostComment]) -> ()){
//        if let query = PostComment.query(){
//            query.whereKey("post", equalTo: post)
//            //query.includeKey("postComment")
//            query.orderByAscending("createdAt")
//            
//            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//                if error == nil, let comments = objects as? [PostComment]{
//                    list(comments: comments)
//                }
//            })
//        }
//    }

//    static func addComment(post: Post, message: String){
//        let postComment = PostComment()
//        postComment.message = message
//        postComment.post = post
//        if let user = PFUser.currentUser(){
//            postComment.user = user
//        }
//        postComment.saveInBackgroundWithBlock { (success, error) -> Void in
//            if success {
//                User.updateScores(.CommentSend, user: User.currentUser(), callback: { (success) -> () in
//                    if success {
//                        println("user send comment")
//                    }
//                })
//                User.updateScores(.CommentReceive, user: post.user, callback: { (success) -> () in
//                    if success {
//                        println("user receive comment")
//                    }
//                })
//                println("save post comment")
//            }else{
//                println("not save post comment")
//            }
//        }
//    }
    
    
}