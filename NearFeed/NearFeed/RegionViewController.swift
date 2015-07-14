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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        Post.findAll { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
        }
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        
        // change indicator view style to white
        tableView.infiniteScrollIndicatorStyle = .White
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            

            tableView.finishInfiniteScroll()
        }
    }
    
    func refresh() {
        //Obter mais dados do servidor
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        Post.findAll { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
        }
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
        return cell
    }
    

}
