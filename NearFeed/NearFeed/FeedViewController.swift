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
    
    @IBOutlet weak var navigationTopView: UIView!
    @IBOutlet weak var labelObjectName: UILabel!
    @IBOutlet weak var labelLocationType: UILabel!

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
        
        navigationTopView.backgroundColor = Color.blue
        labelObjectName.textColor = UIColor.whiteColor()
        labelLocationType.textColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        UserLocation(callback: { (success) -> () in
            if !success {
                println("Nao foi possivel obter sua localizacao: FeedViewController: viewDidLoad")
            }
            Post.find(self.locationObject, type: self.feedType, page: self.pagePost) { (posts) -> () in
                if let posts = posts{
                    self.posts = posts
                    self.tableView.reloadData()
                }else{
                    println("Nenhum post returnado!")
                }
            }
        })
        
        configAlertLocationServices()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        labelObjectName.text = UserLocation.countryName
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshNavbarColor()
        refresh()
    }
    
    func configAlertLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                println()
            default:
                Alert.locationServices(self)
            }
        } else {
            println("Location services are not enabled")
        }
    }
    
    func refreshNavbarColor(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if self.feedType == LocationType.Country{
                self.navigationController?.navigationBar.barTintColor = Color.blue
                self.navigationTopView.backgroundColor = Color.blue
            }
            else if self.feedType == LocationType.City{
                self.navigationController?.navigationBar.barTintColor = Color.green
                self.navigationTopView.backgroundColor = Color.green
            }
            else{
                self.navigationController?.navigationBar.barTintColor = Color.red
                self.navigationTopView.backgroundColor = Color.red
            }
        })
    }
    
    func refresh() {
        if let createdAt = posts.first?.createdAt{
            Post.find(locationObject, type: feedType, greaterThanCreatedAt: createdAt, list: { (posts) -> () in
                if let posts = posts{
                    self.posts.splice(posts, atIndex: 0)
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }else{
                    println("Nenhum post returnado!")
                }
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
                    if let posts = posts{
                        for post in posts{
                            let indexSet = NSIndexSet(index: self.posts.count)
                            self.posts.append(post)
                            self.tableView.insertSections(indexSet, withRowAnimation: .Fade)
                        }
                    }else{
                        println("Nenhum post retornado! ")
                    }
                    self.isLoading = false
                })
            }
        }
    }
    
    //MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            if posts[indexPath.section].images.count == 0{
                return 180
            }
//            posts[indexPath.section].text.boundingRectWithSize(CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesDeviceMetrics, attributes: @{NSFontAttributeName:UIFont()}, context: mil)
            return 400
        }
        return 80
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts[section].comments.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        if indexPath.row == 0, let cell = tableView.dequeueReusableCellWithIdentifier("cellPost", forIndexPath: indexPath) as? PostViewCell {
            cell.post = post
            cell.makePostCell()

            cell.contentView.userInteractionEnabled = true
            
            cell.postImagesScroll.userInteractionEnabled = true
            cell.postImagesScroll.delegate = cell
            
            cell.pageControl?.numberOfPages = cell.post.images.count
            
            if posts[indexPath.section].images.count == 0{
                cell.postImagesScroll.hidden = true
                cell.pageControl.hidden = true
            }
            
            cell.removeImagesFromScrollView()
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            for (index,image) in enumerate(cell.post.images) {
                image.image({ (image) -> () in
                    if let image = image{
                        self.refreshScrollView(cell.postImagesScroll, image: image, index: index, size:cell.post.images.count)
                        cell.addGesturesToSubviews()
                    }
                })
            }
            
            cell.openFocusImage = {(image) in
                if let focusImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageFocus") as? ImageFocusViewController{
                    focusImageViewController.imageToShow = image
                    focusImageViewController.post = cell.post
                    self.presentViewController(focusImageViewController, animated: true, completion: nil)
                }
            }
            return cell
        }else if let cell = tableView.dequeueReusableCellWithIdentifier("cellPostComment", forIndexPath: indexPath) as? PostCommentCell{
            let postComment = post.comments[indexPath.row-1]
            postComment.objectForKey("user")?.fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                if let user = object as? User{
                    cell.userName.text = user.name
                    user.image.image({ (image) -> () in
                        if let img = image{
                            cell.userImage.image = img
                        }
                    })
                }
            })
            cell.postComment.text = postComment.message
            cell.postDate.text = postComment.createdAt?.dateFormat()
            return cell
        }else{
            return UITableViewCell()
        }
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
    
    func commentOnPost(post:Post, comment:String){
        //Metodo pra chamar quando apertar no botao do textfield
    }
    
    func addAccessoryViewOnKeyboard(){
        var keyboardToolbar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44))
        var textField = UITextField(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 40))
//        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: commentOnPost(<#post: Post#>, comment: <#String#>), action: <#Selector#>)
//            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
//            
//            [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
//            [keyboardToolbar addSubview:segmentedControl];
//            [textField setInputAccessoryView:keyboardToolbar];
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterPopover"{
            var popoverFilterViewController = segue.destinationViewController as! FilterPopoverViewController
            popoverFilterViewController.modalPresentationStyle = .Popover
            popoverFilterViewController.popoverPresentationController?.delegate = self
            popoverFilterViewController.preferredContentSize = CGSizeMake(300,400)
            popoverFilterViewController.locationObject = self.locationObject
            popoverFilterViewController.feedType = self.feedType
            popoverFilterViewController.updateFeedToLocation = {(feedType,locationObject) in
                self.locationObject = locationObject
                self.feedType = feedType
                self.refreshNavbarColor()
                self.labelObjectName.text = self.locationObject?.objectForKey("name") as? String
                self.labelLocationType.text = self.feedType.rawValue as String
                Post.find(self.locationObject, type: self.feedType, page: 0, list: { (posts) -> () in
                    if let posts = posts{
                        self.posts = [Post]()
                        self.posts = posts
                        self.tableView.reloadData()
                    }
                })
            }
        }

    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
