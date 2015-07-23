//
//  EditProfileViewController.swift
//  NearFeed
//
//  Created by Alisson Carvalho on 16/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Variaveis globais
    var currentObject : PFObject?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    var email : String?
    
    // MARK: - Outlets
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextField: HoshiTextField!
    @IBOutlet var emailTextField: HoshiTextField!
    
    
    // MARK: - Buttons
    @IBAction func saveBarButton(sender: AnyObject) {
        if let updateObject = currentObject as PFObject? {
            
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            
            
            //currentObject?.setObject(imageFile!, forKey: "image")
            
            //updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveInBackground()
            //updateObject.saveEventually()
            
            println("SALVOU AQUI NO PRIMEIRO")
            
        } else {
            
            
            //PFUser.currentUser()
            //var updateObject = PFUser.currentUser()
            var updateObject = PFObject(className:"User")
            
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            //updateObject.setObject(imageFile!, forKey: "image")
            //updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveInBackground()
            
            println("SALVOU AQUI DEPOIS")
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func changeImageButton(sender: AnyObject) {
        addPhoto()
    }
    @IBAction func changePasswordButton(sender: AnyObject) {
        
        PFUser.requestPasswordResetForEmailInBackground(email!)
        Message.info("Alert", text: "Mensagem enviada para o email")
//        var alerta = UIAlertView(title: "Alerta", message: "Mensagem enviada para o seu email", delegate: self, cancelButtonTitle: "Ok")
//        alerta.show()
        
        
    }
    @IBAction func saveButton(sender: AnyObject) {
        /*
        if let updateObject = currentObject as PFObject? {
            
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            
            
            currentObject?.setObject(imageFile!, forKey: "image")
            
            //updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveInBackground()
            //updateObject.saveEventually()
            
            println("SALVOU AQUI NO PRIMEIRO")
            
        } else {
            
            
            //PFUser.currentUser()
            //var updateObject = PFUser.currentUser()
            var updateObject = PFObject(className:"User")
            
            updateObject["username"] = emailTextField.text
            updateObject["email"] = emailTextField.text
            updateObject["name"] = nameTextField.text
            updateObject.setObject(imageFile!, forKey: "image")
            //updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            updateObject.saveInBackground()
            
            println("SALVOU AQUI")
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        
//        if let object = currentObject {
//            println("PASSOU A REFERENCIA DO ANTIGO OBJECT")
//        }
        
        currentObject = PFUser.currentUser()
        
        imagemRedonda()
        
        if let object = currentObject {
            
            email = object["email"] as? String
            //nameLabel.text = object["name"] as? String
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
            }  else {
                self.imageImageView.image = UIImage(named: "user")
                
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Metodos
    
    func imagemRedonda(){
        imageImageView.layer.borderWidth=1.0
        imageImageView.layer.masksToBounds = false
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.cornerRadius = 13
        imageImageView.layer.cornerRadius = imageImageView.frame.size.height/2
        imageImageView.clipsToBounds = true
        
    }
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
        
        let pickedImage:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        //let imageData = UIImagePNGRepresentation(pickedImage)
        imageFile = PFFile(data: UIImageJPEGRepresentation(pickedImage, 1.0))
        self.imageImageView.image = pickedImage
        currentObject!.setObject(imageFile!, forKey: "image")
        currentObject!.saveInBackground()
        println("PEGOU IMAGEM")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("NAO PEGOU IMAGEM")
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func addPhoto (){
        
        
        let alertaController = UIAlertController(title: "Image from: ", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction?) -> Void in
            self.cameraPhoto()
        })
        
        var libraryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction?) -> Void in
            self.libraryPhoto()
        })
        
        alertaController.addAction(cancelAction)
        alertaController.addAction(cameraAction)
        alertaController.addAction(libraryAction)
        
        presentViewController(alertaController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Metodos para mover a screem para cima quando o teclado aparecer
    //http://www.jogendra.com/2015/01/uitextfield-move-up-when-keyboard.html
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 150)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 150)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
