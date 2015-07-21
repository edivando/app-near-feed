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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postCell.layer.borderColor = UIColor.lightGrayColor().CGColor
        postCell.layer.borderWidth = 0.5
        postCell.layer.cornerRadius = 5
        
        userImage.layer.cornerRadius = 25
        userImage.layer.masksToBounds = true
        
        viewBarButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func makePostCell(){
        userName.text = post.user.name
        if let img = post.user.imageProfile{
            userImage.image = img
        }
        userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        
        postTime.text = post.createdAt?.dateFormat()
        postText.text = post.text

        //slide.delegate = self
        slide.delay = 1
        slide.transitionDuration = 5
        slide.transitionType = KASlideShowTransitionType.Slide
        slide.imagesContentMode = UIViewContentMode.ScaleAspectFit
        slide.addGesture(KASlideShowGestureType.Swipe)
        
        for imagePF in post.images{
            slide.addImage(imagePF.image!)
        }
    }

    @IBAction func postComment(sender: UIButton) {
        
    }

    @IBAction func postLike(sender: UIButton) {
        post.addLike(true)
    }
    
    @IBAction func postDislike(sender: UIButton) {
        post.addLike(false)
    }
}
