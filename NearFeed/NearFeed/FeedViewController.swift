//
//  CityViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var posts = [Post]()
    var pagePost = 0
    var isLoading = false
    var imageFrame = CGRectMake(0, 0, 0, 0)

    //Object do filtro que pode ser country, city ou region
    var locationObject: PFObject?
    
    //Tipo do feed: Country, City or Region
    var feedType: LocationType = .Country
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        Post.find(locationObject, type: feedType, page: pagePost) { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
            
//            UserLocation.updateCountryLocalityParse()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
    }
    
    func refresh() {
        if let createdAt = posts.first?.createdAt{
            Post.find(locationObject, type: feedType, greaterThanCreatedAt: createdAt, list: { (posts) -> () in
                self.posts.splice(posts, atIndex: 0)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    //MARK: - ScrollView Delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 40 {
            if !isLoading, let lastCreatedAt = posts.last?.createdAt{
                isLoading = true
                Post.find(locationObject, type: feedType, lessThanCreatedAt: lastCreatedAt, list: { (posts) -> () in
                    for post in posts{
//                        var indexPath = NSIndexPath(forRow: 0, inSection: self.posts.count)
                        self.posts.append(post)
//                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                    self.tableView.reloadData()
                    self.isLoading = false
                })
            }
        }
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 400
        }
        return 50
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2   //posts[section].comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(indexPath)
        if indexPath.row == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("cellPost", forIndexPath: indexPath) as! PostViewCell
            cell.post = posts[indexPath.section]
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
        
        println("Comment: \(indexPath)")
        let cell = tableView.dequeueReusableCellWithIdentifier("cellPostComment") as! UITableViewCell
        cell.textLabel?.text = "AAAA"
        return cell
    }
    
    //MARK: - Helper (ScrollViewCell)
    
    func refreshScrollView(scrollView:UIScrollView, image:UIImage, index:Int, size:Int){
        imageFrame.origin.x = scrollView.frame.size.width * CGFloat(index)
        imageFrame.size = scrollView.frame.size
        scrollView.pagingEnabled = true
        
        var subView = UIImageView(frame: imageFrame)
        
        subView.image = image
        
        subView.contentMode = UIViewContentMode.ScaleAspectFill
        
        subView.clipsToBounds = true
        
        
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
            var dummyCell = UITableViewCell() //celula pra fazer calculo da altura do popover
            popoverMenuViewController.preferredContentSize = CGSizeMake(150,dummyCell.frame.size.height * 3)
            popoverMenuViewController.feedType = feedType
            popoverMenuViewController.updateFeedToLocation = {(location) in
                self.feedType = location
                Post.find(self.locationObject, type: self.feedType, page: 0, list: { (posts) -> () in
                    self.posts = [Post]()
                    self.posts = posts
                    self.tableView.reloadData()
                })
            }
        }
        else if segue.identifier == "filterPopover"{
            var popoverFilterViewController = segue.destinationViewController as! FilterPopoverViewController
            popoverFilterViewController.modalPresentationStyle = .Popover
            popoverFilterViewController.popoverPresentationController?.delegate = self
            popoverFilterViewController.preferredContentSize = CGSizeMake(250,200)
            popoverFilterViewController.locationObject = self.locationObject
            popoverFilterViewController.feedType = self.feedType
            popoverFilterViewController.updateFeedToLocation = {(locationObject) in
                self.locationObject = locationObject
                Post.find(self.locationObject, type: self.feedType, page: 0, list: { (posts) -> () in
                    self.posts = [Post]()
                    self.posts = posts
                    self.tableView.reloadData()
                })
            }
        }

    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}