//
//  SignupViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate, MBProgressHUDDelegate {
    
    @IBOutlet weak var cancelBt: UIButton!
    @IBOutlet weak var doneBt: UIButton!
    @IBOutlet weak var nameTextfield: HoshiTextField!
    @IBOutlet weak var emailTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: HoshiTextField!
    @IBOutlet weak var verifyPassTextfield: HoshiTextField!
    
    private var progress = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        verifyPassTextfield.delegate = self
        
        self.view.backgroundColor = Color.blue
        
        doneBt.backgroundColor = UIColor.clearColor()
        doneBt.tintColor = UIColor.whiteColor()
        doneBt.layer.cornerRadius = 5
        doneBt.layer.borderWidth = 1
        doneBt.layer.borderColor = UIColor.whiteColor().CGColor
        
        cancelBt.backgroundColor = UIColor.clearColor()
        cancelBt.tintColor = UIColor.whiteColor()
        cancelBt.layer.cornerRadius = 5
        cancelBt.layer.borderWidth = 1
        cancelBt.layer.borderColor = UIColor.whiteColor().CGColor
        
        configProgress()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configProgress(){
        progress = MBProgressHUD(view: view)
        view.addSubview(progress)
        progress.labelText = nil
        progress.dimBackground = true
        progress.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextResponder = UIResponder()
        if textField.isEqual(nameTextfield){
            nextResponder = emailTextfield
            nextResponder.becomeFirstResponder()
        }
        else if textField.isEqual(emailTextfield){
            nextResponder = passwordTextfield
            nextResponder.becomeFirstResponder()
        }
        else if textField.isEqual(passwordTextfield){
            nextResponder = verifyPassTextfield
            nextResponder.becomeFirstResponder()
        }
        else{
            singup(textField)
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textfieldIsNotEmpty(textField: UITextField) -> Bool{
        var rawString = textField.text
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet
        var trimmed = rawString.stringByTrimmingCharactersInSet(whitespace())
        
        if count(trimmed) == 0{
            return false
        }
        else{
            return true
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    func showEmptyTextfieldAlertMessage(){
        progress.hide(true)
        if !textfieldIsNotEmpty(nameTextfield){
            Message.error("Name empty", text: "Please, fill in your name")
        }
        else if !textfieldIsNotEmpty(emailTextfield){
            Message.error("Email empty", text: "Please, fill in your email")
        }
        else if !textfieldIsNotEmpty(passwordTextfield){
            Message.error("Password empty", text: "Please, fill in your password")
        }
        else{
            Message.error("Password verify empty", text: "Please, fill in your password verification")
        }
    }
    
    func showNotMatchingPasswordAlert(){
        progress.hide(true)
        Message.error("Password does not match", text: "The passwords provided do not match")
    }
    
    @IBAction func singup(sender: AnyObject){
        progress.show(true)
        if textfieldIsNotEmpty(nameTextfield) && textfieldIsNotEmpty(emailTextfield) && textfieldIsNotEmpty(passwordTextfield) && textfieldIsNotEmpty(verifyPassTextfield){
            if passwordTextfield.text == verifyPassTextfield.text{
                
                var user = User()
                user.username = emailTextfield.text
                user.email = emailTextfield.text
                user.password = passwordTextfield.text
                user.name = nameTextfield.text
                user.score = 0
                user.signUpInBackgroundWithBlock { (succeded, error) -> Void in
                    if succeded{
                        //Registered and logged in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else{
                        NSLog("\(error)")
                        if error?.code == 202{
                            Message.error("Sign up failed", text: "User already exists")
                        }
                        else if error?.code == 100{
                            Message.error("Sign up failed", text: "Connection error. Trying again...")
                        }
                    }
                    self.progress.hide(true)
                }
            }
            else{
                showNotMatchingPasswordAlert()
            }
            
        }
        else{
            showEmptyTextfieldAlertMessage()
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
