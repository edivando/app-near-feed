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
    var currentUser : User?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    var email : String?
    
    // MARK: - Outlets
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var nameTextField: HoshiTextField!
    @IBOutlet var emailTextField: HoshiTextField!
    
    
    // MARK: - Buttons
    @IBAction func saveBarButton(sender: AnyObject) {
        
        if let user = currentUser{
            
            user["username"] = emailTextField.text
            user["email"] = emailTextField.text
            user["name"] = nameTextField.text
            
            user.saveInBackground()
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
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        
        currentUser = User.currentUser()
        
        imagemRedonda()
        
        if let user = currentUser {
            
            email = user["email"] as? String
            nameTextField.text = user["name"] as! String
            emailTextField.text = user["email"] as! String
            
            imageImageView.image = UIImage(named: "user")
        
            user.image.image({ (image) -> () in
                if let image = image{
                    self.imageImageView.image = image
                }
            })
        }
        
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
        imageFile = PFFile(data: UIImageJPEGRepresentation(pickedImage, 0.1))
        self.imageImageView.image = pickedImage
        currentUser!.setObject(imageFile!, forKey: "image")
        currentUser!.saveInBackground()
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
    

}
