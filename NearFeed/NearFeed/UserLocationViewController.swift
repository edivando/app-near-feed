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
        performSegueWithIdentifier("segueTabBar", sender: self)
    }

    
    
    
    
    
//    func configAlertLocationServices(){
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .AuthorizedAlways, .AuthorizedWhenInUse:
//                println()
//            default:
//                var controller = UIAlertController (title: "Turn On Location Services to Allow “Meet Messenger” Determine Your Location", message: "", preferredStyle: .Alert)
//                controller.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Cancel) { (_) -> Void in
//                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
//                    if let url = settingsUrl {
//                        UIApplication.sharedApplication().openURL(url)
//                    }
//                    })
//                controller.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
//                presentViewController(controller, animated: true, completion: nil)
//            }
//        } else {
//            println("Location services are not enabled")
//        }
//    }
    
    
}
