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
        UserLocation()

    }
    
    override func viewDidAppear(animated: Bool) {
        println("\(UserLocation.country.name) / \(UserLocation.city.name) / \(UserLocation.region.name)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
