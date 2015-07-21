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
    @NSManaged var city: City
    @NSManaged var country: Country
    
    @NSManaged var likes: [PostLike]
    @NSManaged var comments: [PostComment]
    @NSManaged var reports: [PostReport]
    
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
        return "Post"
    }
    
//MARK: Post Region
    static func findByRegion(region: Region, page: Int, list: (posts: [Post])->()){
        if let query = Post.postQuery(page){
            query.whereKey("region", equalTo: region)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByRegion(region: Region, greaterThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", greaterThan: greaterThanCreatedAt)
            query.whereKey("region", equalTo: region)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByRegion(region: Region, lessThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", lessThan: lessThanCreatedAt)
            query.whereKey("region", equalTo: region)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }

//MARK: Post City
    static func findByCity(city: City, page: Int, list: (posts: [Post])->()){
        if let query = Post.postQuery(page){
            query.whereKey("city", equalTo: city)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByCity(city: City, greaterThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", greaterThan: greaterThanCreatedAt)
            query.whereKey("city", equalTo: city)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByCity(city: City, lessThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", lessThan: lessThanCreatedAt)
            query.whereKey("city", equalTo: city)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
//MARK: Post Country
    static func findByCountry(country: Country, page: Int, list: (posts: [Post])->()){
        if let query = Post.postQuery(page){
            query.whereKey("country", equalTo: country)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByCountry(country: Country, greaterThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", greaterThan: greaterThanCreatedAt)
            query.whereKey("country", equalTo: country)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByCountry(country: Country, lessThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", lessThan: lessThanCreatedAt)
            query.whereKey("country", equalTo: country)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    private static func postQuery() -> PFQuery?{
        if let query = Post.query(){
            query.includeKey("user")
            query.includeKey("country")
            query.includeKey("city")
            query.includeKey("region")
            query.includeKey("likes")
            query.orderByDescending("createdAt")
            return query
        }
        return nil
    }
    
    private static func postQuery(page: Int) -> PFQuery?{
        let pageLenght = 5
        if let query = Post.postQuery(){
            query.skip = page * pageLenght
            query.limit = pageLenght
            return query
        }
        return nil
    }
    
    
    
    
    
    
//Mark: Post methods
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
        if let user = User.currentUser() where user.isAuthenticated(){
            self.user = user
            self.country = UserLocation.country
            self.city = UserLocation.city
            self.region = UserLocation.region
            
            self.saveInBackgroundWithBlock { (success, erro) -> Void in
                if erro == nil {
                    User.currentUser()!.updateScores(.NewPost, callback: { (success) -> () in
                        if success {
                            println("Add user scores new post")
                        }
                    })
                    println("save post")
                    error(error: nil)
                }else{
                    error(error: erro)
                    println("not save post")
                }
            }
        }else{
            error(error: NSError(domain: "User_Not_Authenticated", code: 01, userInfo: nil))
        }
    }
    func addVisualization(){
        visualizations = visualizations.integerValue + 1
        saveInBackground()
    }
    
    func addClick(){
        clicked = clicked.integerValue + 1
        saveInBackground()
    }
    
    func addLike(like: Bool){
        let postLike = PostLike()
        postLike.like = like ? 1 : -1
        postLike.post = self
        if let user = User.currentUser(){
            postLike.user = user
        }
        if likes.count == 0{
            likes = [PostLike]()
        }
        likes.append(postLike)
        saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                //Update my scores
                User.currentUser()!.updateScores(.LikeSend, callback: { (success) -> () in
                    if success {
                        println("like post user")
                    }
                })
                self.user.updateScores(like ? .LikeReceive : .DislikeReceive, callback: { (success) -> () in
                    if success {
                        println("post like by user")
                    }
                })
                println("save post like")
            }else{
                println("not save post like")
            }
        }
    }
    
    func addComment(message: String){
        let postComment = PostComment()
        postComment.message = message
        postComment.post = self
        if let user = User.currentUser(){
            postComment.user = user
        }
        if comments.count == 0 {
            comments = [PostComment]()
        }
        comments.append(postComment)
        saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                User.currentUser()!.updateScores(.CommentSend, callback: { (success) -> () in
                    if success {
                        println("user send comment")
                    }
                })
                self.user.updateScores(.CommentReceive, callback: { (success) -> () in
                    if success {
                        println("user receive comment")
                    }
                })
                println("save post comment")
            }else{
                println("not save post comment")
            }
        }
    }
    
    func addReport(message: String){
        let postReport = PostReport()
        postReport.message = message
        postReport.post = self
        if let user = User.currentUser(){
            postReport.user = user
        }
        if reports.count == 0{
            reports = [PostReport]()
        }
        reports.append(postReport)
        saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("save post report")
            }else{
                println("not save post report")
            }
        }
        
    }
    

}
