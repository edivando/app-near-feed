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
    //var currentObject : PFObject?
    var currentObject : PFUser?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    var email : String?
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var pontuacaoLabel: UILabel!
    @IBOutlet var starRatingImageView: UIImageView!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    
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
        
        
        
        //if let object = currentObject {
            
            //nameLabel.text = object["name"] as? String
            //nameTextField.text = object["name"] as! String
            //emailTextField.text = object["email"] as! String
            
            //nameLabel.text = object["email"] as? String
            
            PFUser.requestPasswordResetForEmailInBackground(email!)
            
       // }
        
        var alerta = UIAlertView(title: "Alerta", message: "Mensagem enviada para o seu email", delegate: self, cancelButtonTitle: "Ok")
        alerta.show()
        
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
    
    func arredondarImagem(){
        imageImageView.layer.borderWidth=1.0
        imageImageView.layer.masksToBounds = false
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.cornerRadius = 13
        imageImageView.layer.cornerRadius = imageImageView.frame.size.height/2
        imageImageView.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var maxScore : Float = 100.0
        imagePicker.delegate = self
        
//        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
//        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        //self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
//        self.floatRatingView.maxRating = 5
//        self.floatRatingView.minRating = 1
//        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = false
//        self.floatRatingView.halfRatings = true
//        self.floatRatingView.floatRatings = false
        

        
        currentObject = PFUser.currentUser()
        //imageImageView.frame = CGRectMake(0, 0, 100, 100)
        
        arredondarImagem()
        
        if !PFAnonymousUtils.isLinkedWithUser(currentObject) {
            println("nao anonimo")
            
            
            //currentObject!["score"] = 99
            //currentObject!.saveInBackground()

            
            
            //if let object = currentObject {
                editButton.enabled = true
                signUpButton.hidden = true
                emailLabel.text = currentObject!["email"] as? String
                nameLabel.text = currentObject!["name"] as? String
                
                let number = currentObject!["score"] as? NSNumber
                
                if let num = number {
                    pontuacaoLabel.text = String(stringInterpolationSegment: number!)
                    floatRatingView.rating = Float(Int(Float(num) / maxScore * 5.0))
                } else {
                    pontuacaoLabel.text = String(0)
                }

                
                if let thumbnail = currentObject!["image"] as? PFFile {
                    
                    
                    //imageFile = thumbnail
                    
                    thumbnail.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            println("entrou no thumb")
                            self.imageImageView.image = UIImage(data: imageData!)
                        }
                    })
                } else {
                    self.imageImageView.image = UIImage(named: "user")
                }
            
            
        } else {
            editButton.enabled = false
            signUpButton.hidden = false
            println("anonimo")
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if !PFAnonymousUtils.isLinkedWithUser(currentObject) {
            println("nao anonimo")
            signUpButton.hidden = true
            editButton.enabled = true
            
            if let object = currentObject {
                
                nameLabel.text = object["name"] as? String
                emailLabel.text = object["email"] as? String
                
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
                } else {
                    self.imageImageView.image = UIImage(named: "user")
                }
            }
            
        } else {
            editButton.enabled = false
            signUpButton.hidden = false
            println("anonimo")
        }
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
