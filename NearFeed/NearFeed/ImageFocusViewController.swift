//
//  ImageFocusViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 16/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class ImageFocusViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var imageToShow:UIImage!
    var post:Post!
    
    @IBOutlet var btPostComment: UIButton!
    @IBOutlet var btPostLIke: UIButton!
    @IBOutlet var btPostDislike: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        btPostComment.cornerAndWhiteBorder()
        btPostLIke.cornerAndWhiteBorder()
        btPostDislike.cornerAndWhiteBorder()
        
        imageView.image = imageToShow
        scrollView.delegate = self
        updateZoom()
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = view.bounds.size.width
            let viewHeight = view.bounds.size.height
            
            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(view.bounds.size.width / image.size.width,
                view.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    //MARK: - Popover
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PopoverComment"{
            var popoverCommentViewController = segue.destinationViewController as! PopoverCommentViewController
            popoverCommentViewController.modalPresentationStyle = .Popover
            popoverCommentViewController.post = self.post
            popoverCommentViewController.popoverPresentationController?.delegate = self
            popoverCommentViewController.preferredContentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,300)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBAction func like(){
        println("like")
        post.addLike(true)
    }
    
    @IBAction func done(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dislike(){
        println("dislike")
        post.addLike(false)
    }
    
    @IBAction func comment(){
        println("comment")
    }
    
    @IBAction func report(){
        println("report")
        post.addReport("placeholder")
    }
    
}