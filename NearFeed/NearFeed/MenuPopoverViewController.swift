//
//  MenuPopoverViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 22/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class MenuPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var locationOptions = ["Country", "City", "Region"]
    var feedType:LocationType!
    //var updateFeedToLocation: ()->() = {() in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.scrollEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = locationOptions[indexPath.row]
        if feedType == LocationType.Country && indexPath.row == 0{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else if feedType == LocationType.City && indexPath.row == 1{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else if feedType == LocationType.Region && indexPath.row == 2{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellClicked = tableView.cellForRowAtIndexPath(indexPath)
        if cellClicked?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if indexPath.row == 0{
            feedType = LocationType.Country
            //updateFeedToLocation(feedType)
            
        }
        else if indexPath.row == 1{
            feedType = LocationType.City
            //updateFeedToLocation(feedType)
        }
        else{
            feedType = LocationType.Region
            //updateFeedToLocation(feedType)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

}
