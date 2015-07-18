//
//  PopoverCommentViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 17/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PopoverCommentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!

    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var defaultCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        var defaultCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: Selector("keyboardDidHide:"), name: UIKeyboardDidHideNotification, object: nil)
        self.view.endEditing(true)
        return true
    }
    
    //MARK: - Adjust popover view
    
    func keyboardDidShow(notification: NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {

            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardSize.height, self.view.frame.width, self.view.frame.height)
            
        }
    }
    
    func keyboardDidHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardSize.height, self.view.frame.width, self.view.frame.height)
            
        }
    }
    
    //MARK: - Actions
    
    @IBAction func send(sender: AnyObject) {
    }
    
    @IBAction func done(sender: AnyObject) {
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
