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
    let imagePicker = UIImagePickerController()
    var email : String?
    
    // MARK: - Outlets
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextField: HoshiTextField!
    @IBOutlet var emailTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        imageImageView.toRound()
        
        if let currentUser = User.currentUser(){
            email = currentUser.email
            nameTextField.text = currentUser.name
            emailTextField.text = currentUser.email
        
            currentUser.image.image({ (image) -> () in
                if let image = image{
                    self.imageImageView.image = image
                }
            })
        }
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
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage, let currentUser = User.currentUser(){
            imageImageView.image = pickedImage
            currentUser.image = PFFile(data: UIImageJPEGRepresentation(pickedImage, 0.1))
            currentUser.saveInBackground()
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("NAO PEGOU IMAGEM")
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextResponder = UIResponder()
        if textField.isEqual(nameTextField){
            nextResponder = emailTextField
            nextResponder.becomeFirstResponder()
        }else{
            emailTextField.resignFirstResponder()
        }
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
    
    
    // MARK: - Buttons
    @IBAction func saveBarButton(sender: AnyObject) {
        
        if textfieldIsNotEmpty(nameTextField) && textfieldIsNotEmpty(emailTextField){
   
            if isValidEmail(emailTextField.text){
                
                
                //if User.currentUser()?.username
                
                if let user = User.currentUser(){
                    user.username = emailTextField.text
                    user.email = emailTextField.text
                    user.name = nameTextField.text
                    user.saveInBackground()
                
                    // Return to table view
                    self.navigationController?.popViewControllerAnimated(true)
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
    
    
    @IBAction func changeImageButton(sender: AnyObject) {
        addPhoto()
    }
    
    @IBAction func changePasswordButton(sender: AnyObject) {
        PFUser.requestPasswordResetForEmailInBackground(email!)
        Message.info("Change Password", text: "Sending email: \(email) to recover your account")
    }
    
    // MARK: - Metodos auxiliares
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func showInvalidEmailAlertMessage(){
        //self.progress.hide(true)
        Message.error("Invalid email", text: "The email you provided is invalid")
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
    
    func showEmptyTextfieldAlertMessage(){
        if !textfieldIsNotEmpty(emailTextField) && !textfieldIsNotEmpty(nameTextField) {
            Message.error("Email and Name fields empty", text: "Please fill in your email and name")
            
        } else if !textfieldIsNotEmpty(emailTextField) {
            Message.error("Email field empty", text: "Please fill in your email")
        } else {
            Message.error("Name field empty", text: "Please fill in your name")
        }
    }
    
    // MARK: - Metodos para mover os elementos visuais para cima quando o teclado aparecer
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
    
    
    
    

}
