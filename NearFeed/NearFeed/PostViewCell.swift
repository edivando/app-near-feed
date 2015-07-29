//
//  PostViewCellTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/19/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell, UIScrollViewDelegate {

//    @IBOutlet var postCell: UIView!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userLocality: UILabel!
    
    @IBOutlet var postText: UILabel!
    @IBOutlet var postTime: UILabel!
    @IBOutlet var postVisualizations: UILabel!
    @IBOutlet weak var postImagesScroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    
    @IBOutlet var viewBarButton: UIView!
    var post = Post()
    
    var imageFrame: CGRect = CGRectMake(0, 0, 0, 0)
    
    @IBOutlet var btPostComment: UIButton!
    @IBOutlet var btPostLike: UIButton!
    @IBOutlet var btPostDislike: UIButton!
    
    var openFocusImage: (image:UIImage)->() = {(image) in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        postCell.layer.borderColor = UIColor.lightGrayColor().CGColor
//        postCell.layer.borderWidth = 0.5
//        postCell.layer.cornerRadius = 3
        
        userImage.layer.cornerRadius = 25
        userImage.layer.masksToBounds = true
        
        viewBarButton.backgroundColor = UIColor.blackColor()  //.colorWithAlphaComponent(0.25)
        
        btPostComment.cornerAndWhiteBorder()
        btPostLike.cornerAndWhiteBorder()
        btPostDislike.cornerAndWhiteBorder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth = postImagesScroll.frame.size.width
        var fractionalPage = Double(postImagesScroll.contentOffset.x / pageWidth)
        var page = lround(fractionalPage)
        self.pageControl.currentPage = page;
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){
        let imageView = recognizer.view as! UIImageView
        if let image = imageView.image{
            openFocusImage(image: image)
        }
        post.addClick()
    }
    
    func addGesturesToSubviews(){
        for view in postImagesScroll.subviews{
            if let imageView = view as? UIImageView{
                var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
                imageView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    func removeImagesFromScrollView(){
        for subview in postImagesScroll.subviews{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                subview.removeFromSuperview()
            })
        }
    }
    
    func makePostCell(){
        userName.text = post.user.name
        
        userImage.image = UIImage(named: "user")
        post.user.image.image({ (image) -> () in
            if let img = image{
                self.userImage.image = img
            }
        })

        userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        
        postTime.text = post.createdAt?.dateFormat()
        postText.text = post.text
        postVisualizations.text = post.visualizations.stringValue
        
        countLikeAndComment()
        //Mostra imagem se existir
        let heightConstraint = NSLayoutConstraint(item: postImagesScroll, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250)
        postImagesScroll.removeConstraints(postImagesScroll.constraints())
        if post.images.count > 0{
            postImagesScroll.addConstraint(heightConstraint)
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
    
    func countLikeAndComment(){
        btPostComment.titleLabel?.text = " \(post.comments.count)"
        var countLike = 0
        var countDislike = 0
        for like in post.likes{
            if like.like == 1{
                countLike++
            }else{
                countDislike++
            }
        }
        btPostLike.titleLabel?.text = "\(countLike)"
        btPostDislike.titleLabel?.text = "\(countDislike)"
    }

    @IBAction func postComment(sender: UIButton) {
        
    }

    @IBAction func postLike(sender: UIButton) {
        post.addLike(true, error: { (error) -> () in
            
            println("Error \(error)")
            
        })
        enableLike(false)
        btPostLike.titleLabel?.text = " \(post.likes.count + 1)"
    }
    
    @IBAction func postDislike(sender: UIButton) {
        post.addLike(false, error: { (error) -> () in
        
            println("Error \(error)")
            
        })
        enableLike(false)
        btPostLike.titleLabel?.text = " \(post.likes.count + 1)"
    }

    @IBAction func postReport(sender: AnyObject) {
        println("Report post: \(post.text)")
    }
    
    
}
