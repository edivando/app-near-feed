//
//  CityViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class CityViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var posts = [Post]()
    var pagePost = 0
    var isLoading = false
    var imageFrame = CGRectMake(0, 0, 0, 0)
    var feedType = LocationType.Country
    
    @IBOutlet var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        Post.find(UserLocation.city, type: .City, page: pagePost) { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
        }
        
//        Post.findByCity(UserLocation.city, page: pagePost) { (posts) -> () in
//            self.posts = posts
//            self.tableView.reloadData()
//        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
    }
    
    func refresh() {
        if let createdAt = posts.first?.createdAt{
            Post.findByCity(UserLocation.city, greaterThanCreatedAt: createdAt) { (posts) -> () in
                self.posts.splice(posts, atIndex: 0)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    //MARK: - ScrollView Delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 40 {
            if !isLoading, let lastCreatedAt = posts.last?.createdAt{
                isLoading = true
                self.footerView.hidden = (offset==0) ? true : false
                Post.findByCity(UserLocation.city, lessThanCreatedAt: lastCreatedAt, list: { (posts) -> () in
                    
                    for post in posts{
                        var indexPath = NSIndexPath(forRow: self.posts.count, inSection: 0)
                        self.posts.append(post)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                    
                    self.isLoading = false
                    self.footerView.hidden = true
                })
            }
        }
    }
    
    //MARK: UITableViewDataSource
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 550
//    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostViewCell

        cell.post = posts[indexPath.row]
        cell.makePostCell()
        
        cell.contentView.userInteractionEnabled = true
        
        cell.postImagesScroll.userInteractionEnabled = true
        cell.postImagesScroll.delegate = cell
        
        cell.pageControl?.numberOfPages = cell.post.images.count
        
        cell.removeImagesFromScrollView()
        
        for (index,image) in enumerate(cell.post.images) {
            image.image({ (image) -> () in
                if let image = image{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as! PostViewCell
                        self.refreshScrollView(cellToUpdate.postImagesScroll, image: image, index: index, size:cell.post.images.count)
                        cellToUpdate.addGesturesToSubviews()
                    })
                }
            })
        }
        
        cell.openFocusImage = {(image) in
            var focusImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageFocus") as! ImageFocusViewController
            focusImageViewController.imageToShow = image
            focusImageViewController.post = cell.post
            self.presentViewController(focusImageViewController, animated: true, completion: nil)
        }

        return cell
    }
    
    //MARK: - Helper (ScrollViewCell)
    
    func refreshScrollView(scrollView:UIScrollView, image:UIImage, index:Int, size:Int){
        imageFrame.origin.x = scrollView.frame.size.width * CGFloat(index)
        imageFrame.size = scrollView.frame.size
        scrollView.pagingEnabled = true
        
        var subView = UIImageView(frame: imageFrame)
        
        subView.image = image
        
        subView.contentMode = UIViewContentMode.ScaleAspectFit
        
        subView.userInteractionEnabled = true
        
        scrollView.addSubview(subView)
        
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(size), scrollView.frame.size.height)
        
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverMenu"{
            var popoverMenuViewController = segue.destinationViewController as! MenuPopoverViewController
            popoverMenuViewController.modalPresentationStyle = .Popover
            popoverMenuViewController.popoverPresentationController?.delegate = self
            popoverMenuViewController.preferredContentSize = CGSizeMake(150,150)
            popoverMenuViewController.feedType = feedType
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
