//
//  CountryViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        println("\(UserLocation.countryName) / \(UserLocation.cityName) / \(UserLocation.regionName)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
