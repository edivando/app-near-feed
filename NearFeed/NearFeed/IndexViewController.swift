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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let user = PFUser.currentUser(){
            if user.isAuthenticated(){
                NSLog("Opening app")
                self.performSegueWithIdentifier("startFromIndex", sender: nil)
            }
            else{
                NSLog("Opening login")
                self.performSegueWithIdentifier("login", sender: nil)
            }
        }
        else{
            NSLog("Opening login")
            self.performSegueWithIdentifier("login", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
