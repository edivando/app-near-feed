//
//  LoginViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 12/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let user = PFUser.currentUser(){
            if user.isAuthenticated(){
                NSLog("Opening app")
                self.performSegueWithIdentifier("startFromLogin", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextResponder = UIResponder()
        if textField.isEqual(usernameTextfield){
            nextResponder = passwordTextfield
            nextResponder.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func login(sender: AnyObject){
        //Need to check if the user filled all textfields
        
        PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text) { (user, error) -> Void in
            if (user != nil){
                //Successful login
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                NSLog("\(error)")
                //error code 101 = Invalid login parameters
            }
        }
    }
    
    @IBAction func later(sender: AnyObject){
        self.performSegueWithIdentifier("startFromLogin", sender: nil)
    }
    
    @IBAction func singup(sender: AnyObject){
        self.performSegueWithIdentifier("singup", sender: nil)
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
