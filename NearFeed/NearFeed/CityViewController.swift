//
//  CityViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class CityViewController: UITableViewController {

    var posts = [Post]()
    var pagePost = 0
    var isLoading = false
    
    @IBOutlet var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        Post.findByCity(UserLocation.city, page: pagePost) { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
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
            Post.findByCity(UserLocation.city, greaterThanCreatedAt: createdAt) { (posts) -> () in
                self.posts.splice(posts, atIndex: 0)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
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
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostViewCell
        cell.post = posts[indexPath.row]
        cell.makePostCell()
        
        return cell
    }
    
}
