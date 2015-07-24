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
    
    var selectedCity:City?
    var selectedRegion:Region?
    var selectedCountry:Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.addTarget(self, action: Selector("segmentedClicked:"), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.selectedSegmentIndex = feedType!.hashValue
        
        if feedType == LocationType.Country && locationObject != nil{
            segmentedControl.setEnabled(false, forSegmentAtIndex: 2)
        }
        
        if feedType == LocationType.Country{
            selectedCountry = locationObject as? Country
        }
        else if feedType == LocationType.City{
            selectedCity = locationObject as? City
            selectedCountry = selectedCity?.country
        }
        else{
            selectedRegion = locationObject as? Region
            selectedCity = selectedRegion?.city
            selectedCountry = selectedCity?.country
        }

        requestLocations()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterTableViewCell
        if indexPath.section == 0{
            cell.locationObject = locationsFound[indexPath.row]
            cell.textLabel?.text = cell.locationObject?.objectForKey("name") as? String
        }
        else{
            var location = locationsFound[indexPath.row + 1]
            cell.locationObject = location
            cell.textLabel?.text = location["name"] as? String
        }
        
        if locationObject != nil{
            switch(segmentedControl.selectedSegmentIndex){
            case 0:
                println("Country")
                if let countryLocation = selectedCountry{
                    if cell.locationObject?.objectForKey("name") as! String == countryLocation.name{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        selectedIndexPath = indexPath
                    }
                    else{
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 1:
                println("City")
                if let cityLocation = selectedCity{
                    if cell.locationObject?.objectForKey("name") as! String == cityLocation.name{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        selectedIndexPath = indexPath
                    }
                    else{
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            case 2:
                println("Region")
                if let regionLocation = selectedRegion{
                    if cell.locationObject?.objectForKey("name") as! String == regionLocation.name{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        selectedIndexPath = indexPath
                    }
                    else{
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            default:
                println("deu merda ae")
            }
        }
        else{
            if feedType == LocationType.Region{
                if cell.locationObject?.objectForKey("name") as! String == UserLocation.regionName{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    selectedRegion = cell.locationObject?.objectForKey("name") as? Region
                    selectedIndexPath = indexPath
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            else if feedType == LocationType.City{
                if cell.locationObject?.objectForKey("name") as! String == UserLocation.cityName{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    selectedCity = cell.locationObject?.objectForKey("name") as? City
                    selectedIndexPath = indexPath
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            else if feedType == LocationType.Country{
                if cell.locationObject?.objectForKey("name") as! String == UserLocation.countryName{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    selectedCountry = cell.locationObject?.objectForKey("name") as? Country
                    selectedIndexPath = indexPath
                }
                else{
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if locationsFound.count == 0{
                return 0
            }
            else{
                return 1
            }
        }
        return locationsFound.count - 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var currentSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! FilterTableViewCell

        if segmentedControl.selectedSegmentIndex == 1{
            segmentedControl.setEnabled(true, forSegmentAtIndex: 2)
        }
        
        updateFeedToLocation(feedType: self.feedType!, locationObject: currentSelectedCell.locationObject!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    //MARK: - Helper
    
    func segmentedClicked(sender:UISegmentedControl){
        selectedIndexPath = nil
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
            var city = locationObject?.objectForKey("city") as? PFObject
            Region.findAllByCity(city, result: { (regions) -> () in
                if let regions = regions{
                    self.locationsFound = regions
                    for region in self.locationsFound{
                        if region.objectForKey("name") as! String == UserLocation.regionName && region != self.locationsFound[0]{
                            //trazer city pro inicio do array
                            self.locationsFound.removeAtIndex(control)
                            self.locationsFound.insert(region, atIndex: 0)
                        }
                        control++
                    }
                }
                self.tableView.reloadData()
            })

        }
        else if feedType == LocationType.City{
            var country = locationObject?.objectForKey("country") as? PFObject
            City.findAllByCountry(country, result: { (cities) -> () in
                if let cities = cities{
                    self.locationsFound = cities
                    for city in self.locationsFound{
                        if city.objectForKey("name") as! String == UserLocation.cityName && city != self.locationsFound[0]{
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
                    self.locationsFound = [PFObject]()
                    self.locationsFound = countries
                    for country in self.locationsFound{
                        if country.objectForKey("name") as! String == UserLocation.countryName && country != self.locationsFound[0]{
                            //trazer country pro inicio do array
                            self.locationsFound.removeAtIndex(control)
                            self.locationsFound.insert(country, atIndex: 0)
                        }
                        control++
                    }
                }
                self.tableView.reloadData()
            })
        }
    }

}
