//
//  IndexViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 13/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class IndexViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        if let user = User.currentUser() where user.isAuthenticated(){
            NSLog("Opening app")
            self.performSegueWithIdentifier("startFromIndex", sender: nil)
        }
        else{
            NSLog("Opening login")
            self.performSegueWithIdentifier("login", sender: nil)
        }
    }

}
