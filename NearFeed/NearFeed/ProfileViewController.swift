//
//  ProfileViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    // MARK: - Variaveis globais 
    var currentObject : PFObject?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    
    // MARK: - Buttons
    @IBAction func photoLibraryButton(sender: AnyObject) {
        libraryPhoto()
    }
    
    @IBAction func editBarButton(sender: AnyObject) {
        
    }
   
    @IBAction func photoCameraButton(sender: AnyObject) {
        cameraPhoto()
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
    }
    
    @IBAction func savePerfilButton(sender: AnyObject) {
        
        if let updateObject = currentObject as PFObject? {
  
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            
            
            currentObject?.setObject(imageFile!, forKey: "image")
            
            
            updateObject.saveEventually()
            
            currentObject?.saveInBackground()
            
        } else {
            

            //PFUser.currentUser()
            //var updateObject = PFUser.currentUser()
            var updateObject = PFObject(className:"User")
            
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            updateObject.setObject(imageFile!, forKey: "image")
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveInBackground()
       
            
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    // MARK: - Metodos
    func libraryPhoto(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func cameraPhoto(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let pickedImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let imageData = UIImagePNGRepresentation(pickedImage)
        imageFile = PFFile(data: UIImageJPEGRepresentation(pickedImage, 1.0))
        self.imageImageView.image = pickedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        //nameTextField.delegate = self
        //emailTextField.delegate = self
        
        currentObject = PFUser.currentUser()
        
        if let object = currentObject {
            
            nameLabel.text = object["name"] as? String
            //nameTextField.text = object["name"] as! String
            //emailTextField.text = object["email"] as! String
            
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
