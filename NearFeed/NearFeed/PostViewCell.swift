//
//  PostViewCellTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/19/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet var postCell: UIView!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userLocality: UILabel!
    
    @IBOutlet var postText: UITextView!
    
    @IBOutlet weak var postImagesScroll: UIScrollView!
    @IBOutlet var postTime: UILabel!
    
    @IBOutlet var viewBarButton: UIView!
    var post = Post()
    
    var imageFrame: CGRect = CGRectMake(0, 0, 0, 0)
    
    @IBOutlet var btPostComment: UIButton!
    @IBOutlet var btPostLike: UIButton!
    @IBOutlet var btPostDislike: UIButton!
    
    var openFocusImage: (image:UIImage)->() = {(image) in}
    
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
    
    //MARK: - ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func refreshScrollView(){
        //pageControl.numberOfPages = post.images.count
        for index in 0..<post.images.count {
            
            imageFrame.origin.x = self.postImagesScroll.frame.size.width * CGFloat(index)
            imageFrame.size = self.postImagesScroll.frame.size
            self.postImagesScroll.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)

            post.images[index].image({ (image) -> () in
                subView.image = image
            })
            
            var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            
            subView.addGestureRecognizer(tapGesture)
            subView.userInteractionEnabled = true
            
            self.postImagesScroll.addSubview(subView)
        }
        postImagesScroll.contentInset = UIEdgeInsetsZero
        self.postImagesScroll.contentSize = CGSizeMake(self.postImagesScroll.frame.size.width * CGFloat(post.images.count), postImagesScroll.frame.size.height)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){
        let imageView = recognizer.view as! UIImageView
        if let image = imageView.image{
            openFocusImage(image: image)
        }
    }
    
    func makePostCell(){
        userName.text = post.user.name
        
        post.user.image.image({ (image) -> () in
            if let img = image{
                self.userImage.image = img
            }
        })
        userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        
        postTime.text = post.createdAt?.dateFormat()
        postText.text = post.text
        
        btPostComment.titleLabel?.text = " \(post.comments.count)"
        btPostLike.titleLabel?.text = " \(post.likes.count)"
        
        refreshScrollView()
        
        println("Likes: \(post.likes.count)")
        println("Reports: \(post.reports.count)")
        println("Cliked: \(post.clicked)")
        println("Visualizations: \(post.visualizations)")
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
