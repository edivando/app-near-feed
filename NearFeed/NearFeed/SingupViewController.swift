//
//  SingupViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class SingupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func singup(sender: AnyObject){
        var user = PFUser()
        user.username = "Username"
        user.password = "Password"
        user.email = "Email"
        user.signUpInBackgroundWithBlock { (succeded, error) -> Void in
            if succeded{
                //Registered and logged in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                NSLog("\(error)")
            }
        }
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
