//
//  CountryViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {

    var posts = [Post]()
    var pagePost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        Post.findByCountry(UserLocation.country, page: pagePost) { (posts) -> () in
//            self.posts = posts
//            self.tableView.reloadData()
//        }
//
//        println("\(UserLocation.countryName) / \(UserLocation.cityName) / \(UserLocation.regionName)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //MARK: UITableViewDataSource
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostViewCell
//        cell.post = posts[indexPath.row]
//        cell.makePostCell()
//        
//        return cell
//    }

}
