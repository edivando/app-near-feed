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
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("5WIPxHRr0VQ9hYflYvo19uePKLoZiaguRduNXEiw", clientKey: "DJsU1ECZG5nu0MUwlhwhoph79Iew3qa2UUKpVB94")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        User.registerSubclass()
        Country.registerSubclass()
        City.registerSubclass()
        Region.registerSubclass()
        Post.registerSubclass()
        PostLike.registerSubclass()
        PostComment.registerSubclass()
        PostReport.registerSubclass()
        
        return true
    }
    
}

