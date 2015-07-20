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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        Post.findByCity(UserLocation.city, page: pagePost) { (posts) -> () in
            self.posts = posts
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostViewCell
        let post = posts[indexPath.row]
        if let userName = post.user["name"] as? String{
            cell.userName.text = userName
        }
        if let img = post.user.imageProfile{
            cell.userImage.image = img
        }
        
        //cell.slide.delegate = self
        cell.slide.delay = 1
        cell.slide.transitionDuration = 5
        cell.slide.transitionType = KASlideShowTransitionType.Slide
        cell.slide.imagesContentMode = UIViewContentMode.ScaleAspectFit
        cell.slide.addGesture(KASlideShowGestureType.Swipe)
        
        for imagePF in post.images{
            cell.slide.addImage(imagePF.image!)
        }
        cell.userLocality.text = "\(post.country.name) / \(post.city.name) / \(post.region.name)"
        
        //cell.textLabel?.text = "aa"
        return cell
    }
    
}
