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
    
    
    let countryName = UserLocation.countryName
    let cityName = UserLocation.cityName
    let regionName = UserLocation.regionName
    

    
//MARK: Finds Post Methods
    static func find(object: PFObject?, type: LocationType, page: Int, list: (posts: [Post])->()){
        let pageLenght = 5
        if let query = Post.postQuery(object, type: type){
            query.skip = page * pageLenght
            query.limit = pageLenght
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func find(object: PFObject?, type: LocationType, greaterThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(object, type: type){
            query.whereKey("createdAt", greaterThan: greaterThanCreatedAt)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }

    static func find(object: PFObject?, type: LocationType, lessThanCreatedAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(object, type: type){
            query.whereKey("createdAt", lessThan: lessThanCreatedAt)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }

    
//MARK: Querys Methods
    private static func postQuery(object: PFObject?, type: LocationType) -> PFQuery?{
        if let query = Post.query(){
            query.includeKey("user")
            query.includeKey("country")
            query.includeKey("city")
            query.includeKey("region")
            query.includeKey("likes")
            query.includeKey("comments")
            switch(type){
            case .Region:
                if let obj = object, let region = obj as? Region{
                    query.whereKey("region", equalTo: region)
                }else if let obj = UserLocation.region.objectId{
                    query.whereKey("region", equalTo: UserLocation.region)
                }else if let regionQuery = Region.queryByName(UserLocation.regionName){
                    query.whereKey("region", matchesQuery: regionQuery)
                }
            case .City:
                if let obj = object, let city = obj as? City{
                    query.whereKey("city", equalTo: city)
                }else if let obj = UserLocation.city.objectId{
                    query.whereKey("city", equalTo: UserLocation.city)
                }else if let cityQuery = City.queryByName(UserLocation.cityName){
                    query.whereKey("city", matchesQuery: cityQuery)
                }
            default:
                if let obj = object, let country = obj as? Country{
                    query.whereKey("country", equalTo: country)
                }else if let obj = UserLocation.country.objectId{
                    query.whereKey("country", equalTo: UserLocation.country)
                }else if let countryQuery = Country.queryByName(UserLocation.countryName){
                    query.whereKey("country", matchesQuery: countryQuery)
                }
            }
            query.orderByDescending("createdAt")
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
                    User.currentUser()!.updateScores(.NewPost)
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
                User.currentUser()!.updateScores(.LikeSend)
                self.user.updateScores(like ? .LikeReceive : .DislikeReceive)
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
                User.currentUser()!.updateScores(.CommentSend)
                self.user.updateScores(.CommentReceive)
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
