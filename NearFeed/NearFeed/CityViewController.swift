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
            Post.findByCity(UserLocation.city, createdAt: createdAt) { (posts) -> () in
                self.posts.splice(posts, atIndex: 0)
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
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
