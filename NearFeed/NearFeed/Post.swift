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
    static func findByRegionNewPosts(region: Region, createdAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.query(){
            query.whereKey("region", equalTo: region)
            query.whereKey("createdAt", greaterThan: createdAt)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }

    }
    
    static func findByRegion(region: Region, page: Int, list: (posts: [Post])->()){
        if let query = Post.query(){
            query.skip = page * 5
            query.limit = 5
            query.whereKey("region", equalTo: region)
            query.orderByDescending("createdAt")
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
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
    
    static func findByCity(city: City, createdAt: NSDate, list: (posts: [Post])->()){
        if let query = Post.postQuery(){
            query.whereKey("createdAt", greaterThan: createdAt)
            query.whereKey("city", equalTo: city)
            query.orderByDescending("createdAt")
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
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let posts = objects as? [Post]{
                    list(posts: posts)
                }
            })
        }
    }
   
//Mark: Post
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
                    User.updateScores(.NewPost, user: User.currentUser(), callback: { (success) -> () in
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
    
    static func updateClicked(callback: (success: Bool)->()){
        let post = Post()
        post.clicked = post.clicked.integerValue + 1
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                callback(success: success)
            }
        }
    }
    
    private static func postQuery() -> PFQuery?{
        if let query = Post.query(){
            query.includeKey("user")
            query.includeKey("country")
            query.includeKey("city")
            query.includeKey("region")
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

}
