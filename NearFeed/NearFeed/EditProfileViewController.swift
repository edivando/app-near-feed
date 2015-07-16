//
//  EditProfileViewController.swift
//  NearFeed
//
//  Created by Alisson Carvalho on 16/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextView: HoshiTextField!
    @IBOutlet var emailTextView: HoshiTextField!
    
    
    // MARK: - Buttons
    
    @IBAction func changeImageButton(sender: AnyObject) {
    }
    @IBAction func saveButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
