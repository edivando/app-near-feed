//
//  UserLocationViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/19/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import CoreLocation

class UserLocationViewController: UIViewController, CLLocationManagerDelegate, MBProgressHUDDelegate {

    private let locationManager = CLLocationManager()
    private var progress = MBProgressHUD()
    
    private var locationAuthorized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        progress = MBProgressHUD(view: view)
        view.addSubview(progress)
        progress.labelText = "Loading..."
        progress.dimBackground = true
        progress.delegate = self
        progress.show(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if locationAuthorized {
            performSegueWithIdentifier("segueTabBar", sender: self)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        switch(status) {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationAuthorized = true
            viewDidAppear(true)
        default:
            locationAuthorized = false
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationAuthorized = true
        viewDidAppear(true)
    }

    
}
