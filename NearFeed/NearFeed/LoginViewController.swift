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
    
    //MARK: - Textfield input tests
    
    func textfieldIsNotEmpty(textField: UITextField) -> Bool{
        if textField.text == ""{
            return false
        }
        else{
            return true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    //MARK: - Error alerts
    
    func showEmptyTextfieldAlertMessage(){
        if !textfieldIsNotEmpty(usernameTextfield){
            Message.error("Email field empty", text: "Please fill in your email")
        }
        else{
            Message.error("Password field empty", text: "Please fill in your password")
        }
    }
    
    func showInvalidEmailAlertMessage(){
        Message.error("Invalid email", text: "The email you provided is invalid")
    }
    
    //MARK: - Buttons
    
    @IBAction func login(sender: AnyObject){
        if textfieldIsNotEmpty(usernameTextfield) && textfieldIsNotEmpty(passwordTextfield){
            if isValidEmail(usernameTextfield.text){
                PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text) { (user, error) -> Void in
                    if (user != nil){
                        //Successful login
                        Message.success("Success", text: "Login successful")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else{
                        NSLog("\(error)")
                        if error?.code == 101{
                            Message.error("Login failed", text: "Invalid login credentials")
                        }
                        else if error?.code == 100{
                            Message.error("Login failed", text: "Timed out. Please, try again")
                        }
                        else if error?.code == -1{
                            Message.error("Login failed", text: "An unknown error has occurred")
                        }
                        else if error?.code == 1{
                            Message.error("Login failed", text: "Internal server error")
                        }
                    }
                }
            }
            else{
                showInvalidEmailAlertMessage()
            }
        }
        else{
            showEmptyTextfieldAlertMessage()
        }
        
        
    }
    
    @IBAction func later(sender: AnyObject){
        PFAnonymousUtils.logInWithBlock { (user, error) -> Void in
            if error == nil{
                self.performSegueWithIdentifier("startFromLogin", sender: nil)
            }else{
                Message.error("Login", text: "Error")
            }
        }
        
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
