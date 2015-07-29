//
//  LoginViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 12/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate, MBProgressHUDDelegate {

    @IBOutlet weak var signupBt: UIButton!
    @IBOutlet weak var notNowBut: UIButton!
    @IBOutlet weak var loginBt: UIButton!
    @IBOutlet weak var usernameTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: HoshiTextField!
    
    private var progress = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        self.view.backgroundColor = Color.blue
        
        signupBt.backgroundColor = UIColor.clearColor()
        signupBt.tintColor = UIColor.whiteColor()
        signupBt.layer.cornerRadius = 5
        signupBt.layer.borderWidth = 1
        signupBt.layer.borderColor = UIColor.whiteColor().CGColor
        
        loginBt.backgroundColor = UIColor.clearColor()
        loginBt.tintColor = UIColor.whiteColor()
        loginBt.layer.cornerRadius = 5
        loginBt.layer.borderWidth = 1
        loginBt.layer.borderColor = UIColor.whiteColor().CGColor
        
        notNowBut.backgroundColor = UIColor.clearColor()
        notNowBut.tintColor = UIColor.whiteColor()
        notNowBut.layer.cornerRadius = 5
        notNowBut.layer.borderWidth = 1
        notNowBut.layer.borderColor = UIColor.whiteColor().CGColor
        
        configProgress()
        configIntroPage()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let user = User.currentUser(){
            if user.isAuthenticated(){
                NSLog("Opening app")
                self.performSegueWithIdentifier("startFromLogin", sender: nil)
            }
        }
    }
    
    func configProgress(){
        progress = MBProgressHUD(view: view)
        view.addSubview(progress)
        progress.labelText = nil
        progress.dimBackground = true
        progress.delegate = self
    }
    
    func configIntroPage(){
        let size = UIScreen.mainScreen().bounds
        let page01 = introPage("Welcome to NAME", descKey: "Here you can see everything that's taking place around you, in your community, neighborhood, city or country.", image: "teste", color: Color.red)
        
        let page02 = introPage("Filter what you want to see", descKey: "Filter feeds by region, city or country.", image: "teste", color: Color.orange)
        
        let page03 = introPage("Make posts at the location you are", descKey: "Get popular by posting relevant information. If your post gets popular, it will be promoted to the city status or maybe even the country status, being visible to more people.", image: "teste", color: Color.yellow)
        
        let page04 = introPage("Rank up and get seen as a helpful user", descKey: " Your actions will have more impact inside the app.", image: "teste", color: Color.green)
        
        let intro = EAIntroView(frame: self.view.frame, andPages: [page01,page02,page03,page04])
        intro.pageControl.hidden = false
        intro.showInView(self.view, animateDuration: 0.3)
    }
    
    func introPage(titleKey: String, descKey: String, image: String, titleSize: CGFloat = 20, color: UIColor, descSize: CGFloat = 15, yTitleIcon: CGFloat = 20, yTitle: CGFloat = 160, yDesc: CGFloat = 140) -> EAIntroPage{
        
        let page = EAIntroPage()
        page.title = titleKey
        page.titlePositionY = yTitle
        page.desc = descKey
        page.descPositionY = yDesc
        page.bgColor = color
        page.titleIconView = UIImageView(image: UIImage(named: image))
        page.titleIconPositionY = yTitleIcon
        return page
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextResponder = UIResponder()
        if textField.isEqual(usernameTextfield){
            nextResponder = passwordTextfield
            nextResponder.becomeFirstResponder()
        }
        else{
            login(textField)
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    //MARK: - Textfield input tests
    
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    //MARK: - Error alerts
    
    func showEmptyTextfieldAlertMessage(){
        self.progress.hide(true)
        if !textfieldIsNotEmpty(usernameTextfield){
            Message.error("Email field empty", text: "Please fill in your email")
        }
        else{
            Message.error("Password field empty", text: "Please fill in your password")
        }
    }
    
    func showInvalidEmailAlertMessage(){
        self.progress.hide(true)
        Message.error("Invalid email", text: "The email you provided is invalid")
    }
    
    //MARK: - Buttons
    
    @IBAction func login(sender: AnyObject){
        progress.show(true)
        if textfieldIsNotEmpty(usernameTextfield) && textfieldIsNotEmpty(passwordTextfield){
            if isValidEmail(usernameTextfield.text){
                User.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text) { (user, error) -> Void in
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
                    self.progress.hide(true)
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
    
    // MARK: - Metodos para mover os elementos visuais para cima quando o teclado aparecer
    //http://www.jogendra.com/2015/01/uitextfield-move-up-when-keyboard.html
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if textField.tag == 0 {
            animateViewMoving(true, moveValue: 0)
        } else if textField.tag == 1 {
            animateViewMoving(true, moveValue: 40)
        }
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        
        if textField.tag == 0 {
            animateViewMoving(false, moveValue: 0)
        } else if textField.tag == 1 {
            animateViewMoving(false, moveValue: 40)
        }
        
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

}
