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
    
    var post = Post()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postCell.layer.borderColor = UIColor.lightGrayColor().CGColor
        postCell.layer.borderWidth = 0.5
        postCell.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makePostCell(){
        if let name = post.user["name"] as? String{
            userName.text = name
        }
        if let img = post.user.imageProfile{
            userImage.image = img
        }
        
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
        userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
    }

    @IBAction func postComment(sender: UIButton) {
        
    }

    @IBAction func postLike(sender: UIButton) {
        PostLike.addLike(post, like: true)
    }
    
    @IBAction func postDislike(sender: UIButton) {
        PostLike.addLike(post, like: false)
    }
}
