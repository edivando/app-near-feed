//
//  RegionViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class RegionViewController: UITableViewController {

    private var posts = [Post]()
    
    private var pagePost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
//        Post.findByRegion(UserLocation.region, page: pagePost, list: { (posts) -> () in
//            self.posts = posts
//            self.tableView.reloadData()
//        })
  
        
        
       
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
//        if tableView.respondsToSelector("layoutMargins") {
//            tableView.estimatedRowHeight = 88
//            tableView.rowHeight = UITableViewAutomaticDimension
//        }
//        
    }
    
    func refresh() {
//        pagePost = 0
//        Post.findByRegion(location.region, page: pagePost, list: { (posts) -> () in
//            self.posts = posts
//            self.tableView.reloadData()
//            self.refreshControl?.endRefreshing()
//        })
    }

//MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.postText.text = post.text
        if let imgData = post.images.first?.getData(){
            cell.postImage.image = UIImage(data: imgData)
        }else{
            cell.postImage.image = nil
        }
        if let userName = post.user["name"] as? String{
            cell.userName.text = userName
        }
        cell.postLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        return cell
    }
    
    

}
