//
//  SingupViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextfield: HoshiTextField!
    @IBOutlet weak var emailTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: HoshiTextField!
    @IBOutlet weak var verifyPassTextfield: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        verifyPassTextfield.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textfieldIsNotEmpty(textField: UITextField) -> Bool{
        if textField.text == ""{
            return false
        }
        else{
            return true
        }
    }
    
    func showEmptyTextfieldAlertMessage(){
        //Verificar quem esta vazio e mostrar o alerta correspondente
    }
    
    func showNotMatchingPasswordAlert(){
        
    }
    
    @IBAction func singup(sender: AnyObject){
        if textfieldIsNotEmpty(nameTextfield) && textfieldIsNotEmpty(emailTextfield) && textfieldIsNotEmpty(passwordTextfield) && textfieldIsNotEmpty(verifyPassTextfield){
            if passwordTextfield.text == verifyPassTextfield.text{
                
                var user = PFUser()
                user.username = emailTextfield.text
                user.email = emailTextfield.text
                user.password = passwordTextfield.text
                user["name"] = nameTextfield.text
                user.signUpInBackgroundWithBlock { (succeded, error) -> Void in
                    if succeded{
                        //Registered and logged in
                    }
                    else{
                        NSLog("\(error)")
                    }
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
    
    
    /*
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
