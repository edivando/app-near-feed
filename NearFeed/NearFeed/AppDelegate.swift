//
//  AppDelegate.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/8/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("5WIPxHRr0VQ9hYflYvo19uePKLoZiaguRduNXEiw", clientKey: "DJsU1ECZG5nu0MUwlhwhoph79Iew3qa2UUKpVB94")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        UserLocation()
        User.registerSubclass()
        return true
    }
    
}

