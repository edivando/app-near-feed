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

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var locationObject: PFObject?
    var feedType: LocationType?
    var updateFeedToLocation: (feedType: LocationType,locationObject:PFObject)->() = {(feedType, locationObject) in}
    var locationsFound = [PFObject]()
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.addTarget(self, action: Selector("segmentedClicked:"), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.selectedSegmentIndex = feedType!.hashValue

        requestLocations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //se o locationobject q vier for igual a o da celula, marca
        
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterTableViewCell
        if indexPath.section == 0{
            cell.locationObject = locationsFound[0]
            cell.textLabel?.text = cell.locationObject?.objectForKey("name") as? String
        }
        else{
            var location = locationsFound[indexPath.row + 1]
            cell.locationObject = location
            cell.textLabel?.text = location["name"] as? String
        }

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return locationsFound.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var previousSelectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath!) as! FilterTableViewCell
        var currentSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! FilterTableViewCell
        
        if previousSelectedCell == currentSelectedCell{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else{
            selectedIndexPath = indexPath
            previousSelectedCell.accessoryType = UITableViewCellAccessoryType.None
            currentSelectedCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //updateFeedToLocation(locationObject: currentSelectedCell.locationObject!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK: - Helper
    
    func segmentedClicked(sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            //Country
            self.feedType = LocationType.Country
        }
        else if sender.selectedSegmentIndex == 1{
            //City
            self.feedType = LocationType.City
        }
        else{
            //Region
            self.feedType = LocationType.Region
        }
        requestLocations()
    }
    
    func requestLocations(){
        var control = 0
        if feedType == LocationType.Region{
//            var city = locationObject?.objectForKey("city") as? PFObject
//            Region.findAllByCity(city, result: { (regions) -> () in
//                if let regions = regions{
//                    self.locationsFound = regions
//                    self.tableView.reloadData()
//                }
//            })
        }
        else if feedType == LocationType.City{
            var country = locationObject?.objectForKey("country") as? PFObject
            City.findAllByCountry(country, result: { (cities) -> () in
                if let cities = cities{
                    self.locationsFound = cities
                    for city in self.locationsFound{
                        if city.objectForKey("name") as! String == UserLocation.cityName{
                            //trazer city pro inicio do array
                            self.locationsFound.removeAtIndex(control)
                            self.locationsFound.insert(city, atIndex: 0)
                        }
                        control++
                    }
                }
                self.tableView.reloadData()
            })
        }
        else{
            Country.findAll({ (countries) -> () in
                if let countries = countries{
                    self.locationsFound = countries
                    self.tableView.reloadData()
                }
            })
        }
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
