//
//  PostViewCellTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/19/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {

    @IBOutlet var postCell: UIView!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userLocality: UILabel!
    
    @IBOutlet var postText: UITextView!
    
    @IBOutlet weak var slide: KASlideShow!
    @IBOutlet var postTime: UILabel!
    
    @IBOutlet var viewBarButton: UIView!
    var post = Post()
    
    @IBOutlet var btPostComment: UIButton!
    @IBOutlet var btPostLike: UIButton!
    @IBOutlet var btPostDislike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postCell.layer.borderColor = UIColor.lightGrayColor().CGColor
        postCell.layer.borderWidth = 0.5
        postCell.layer.cornerRadius = 5
        
        userImage.layer.cornerRadius = 25
        userImage.layer.masksToBounds = true
        
        viewBarButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        
        btPostComment.layer.borderColor = UIColor.whiteColor().CGColor
        btPostComment.layer.borderWidth = 1
        btPostComment.layer.cornerRadius = 5
        
        btPostLike.layer.borderColor = UIColor.whiteColor().CGColor
        btPostLike.layer.borderWidth = 1
        btPostLike.layer.cornerRadius = 5
        
        btPostDislike.layer.borderColor = UIColor.whiteColor().CGColor
        btPostDislike.layer.borderWidth = 1
        btPostDislike.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func makePostCell(){
//        userName.text = post.user.name
//        
//        post.user.image.image({ (image) -> () in
//            if let img = image{
//                self.userImage.image = img
//            }
//        })
        userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        
        postTime.text = post.createdAt?.dateFormat()
        postText.text = post.text
        
        btPostComment.titleLabel?.text = " \(post.comments.count)"
        
        
        btPostLike.titleLabel?.text = " \(post.likes.count)"
        if isUserLike() {
            enableLike(false)
        }else{
            enableLike(true)
        }
        
        println("Likes: \(post.likes.count)")
        println("Reports: \(post.reports.count)")
        println("Cliked: \(post.clicked)")
        println("Visualizations: \(post.visualizations)")

        //slide.delegate = self
        slide.images = NSMutableArray()
        slide.delay = 1
        slide.transitionDuration = 5
        slide.transitionType = KASlideShowTransitionType.Slide
        slide.imagesContentMode = UIViewContentMode.ScaleAspectFit
        slide.addGesture(KASlideShowGestureType.Swipe)
        
        for imagePF in post.images{
            imagePF.image({ (image) -> () in
                if let img = image{
                    self.slide.addImage(img)
                }
            })
        }
    }
    
    func isUserLike() ->Bool{
        for postLike in post.likes{
            if let likeObjId = postLike.user.objectId, let userId = User.currentUser()?.objectId{
                if likeObjId == userId{
                    return true
                }
            }
        }
        return false
    }
    
    func enableLike(value: Bool){
        btPostLike.enabled = value
        btPostDislike.enabled = value
    }

    @IBAction func postComment(sender: UIButton) {
        
    }

    @IBAction func postLike(sender: UIButton) {
        post.addLike(true)
        enableLike(false)
        btPostLike.titleLabel?.text = " \(post.likes.count + 1)"
    }
    
    @IBAction func postDislike(sender: UIButton) {
        post.addLike(false)
        enableLike(false)
        btPostLike.titleLabel?.text = " \(post.likes.count + 1)"
        
    }

    
    
}
