//
//  ProfileViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        currentObject = PFUser.currentUser()
        
        if let object = currentObject {
            
            nameTextField.text = object["name"] as! String
            emailTextField.text = object["email"] as! String
            
            if let thumbnail = object["image"] as? PFFile {
                
                //var userPhoto = PFObject(className: "postString")
                
                imageFile = thumbnail
                
                thumbnail.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        self.imageImageView.image = UIImage(data: imageData!)
                    }
                })
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
            nameTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
        return true
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
