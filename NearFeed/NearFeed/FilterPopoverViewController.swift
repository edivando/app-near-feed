//
//  FilterPopoverViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 22/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class FilterPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var locationObject: PFObject?
    var feedType: LocationType?
    var updateFeedToLocation: (locationObject:PFObject)->() = {(locationObject) in}
    var locationsFound:[PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if feedType == LocationType.Region{
            //query for all regions in that city
            //completion block calls reload data
            //Region.findByName(<#name: String#>, success: <#(regions: Region?) -> ()##(regions: Region?) -> ()#>)
        }
        else if feedType == LocationType.City{
            //query for all cities in that country
            //completion block calls reload data
        }
        else{
            //query for all countries
            //completion block calls reload data
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
