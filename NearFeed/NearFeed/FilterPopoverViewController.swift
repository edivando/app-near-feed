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
    var locationsFound = [PFObject]()
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //locationsFound.append(locationObject!)
        
        //Código dummy pra testes
        var dummyQuery = PFQuery(className: "City")
        dummyQuery.whereKey("name", equalTo: "Fortaleza")
        dummyQuery.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if error == nil{
                
                //Usar a partir daqui dentro dos ifs (fazer os outros metodos de findAll)
                Region.findAllRegionsInCity(object!, result: { (regions) -> () in
                    if let regions = regions{
                        self.locationsFound = regions
//                        for index in 1..<regions.count{
//                            self.locationsFound[index] = regions[index-1]
//                        }
                        self.tableView.reloadData()
                    }
                })
            }
        }
        
        if feedType == LocationType.Region{
            //query for all regions in that city
            //completion block calls reload data
            //Region.findAllRegionsInCity(locationObject["city"], result: <#(regions: [Region]?) -> ()##(regions: [Region]?) -> ()#>)
        }
        else if feedType == LocationType.City{
            //query for all cities in that country
            //completion block calls reload data
            //City.findAllCitiesInCountry(locationObject["country"], result: )
        }
        else{
            //query for all countries
            //completion block calls reload data
            //Country.findAllCountries(result: )
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            selectedIndexPath = indexPath
//        }
        var cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterTableViewCell
        var location = locationsFound[indexPath.row]
        cell.locationObject = location
        cell.textLabel?.text = location["name"] as? String

        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            
            updateFeedToLocation(locationObject: currentSelectedCell.locationObject!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
