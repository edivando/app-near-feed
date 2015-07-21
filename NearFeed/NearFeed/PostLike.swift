//
//  PostLike.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/14/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class PostLike: PFObject, PFSubclassing {
    
    @NSManaged var like: NSNumber
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
        return "PostLike"
    }
    
//    func findAll(){
//        if let query = PostLike.query(){
//            if let posts = query.findObjects() as? [PostLike]{
//                for post in posts{
//                    println(post)
//                }
//            }
//        }
//    }
   
//    
//    static func addLike(post: Post, like: Bool){
//        let postLike = PostLike()
//        postLike.like = like ? 1 : -1
//        postLike.post = post
//        if let user = PFUser.currentUser(){
//            postLike.user = user
//        }
//        post.saveInBackgroundWithBlock { (success, error) -> Void in
//            if success {
//                //Update my scores
//                User.updateScores(.LikeSend, user: User.currentUser(), callback: { (success) -> () in
//                    if success {
//                        println("like post user")
//                    }
//                })
//                User.updateScores(like ? .LikeReceive : .DislikeReceive, user: post.user, callback: { (success) -> () in
//                    if success {
//                        println("post like by user")
//                    }
//                })
//                println("save post like")
//            }else{
//                println("not save post like")
//            }
//        }
//    }
}
