//
//  ProfileViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // MARK: - Variaveis globais
    var currentObject : PFUser?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    var email : String?
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var pontuacaoLabel: UILabel!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var maxScore : Float = 100.0
        imagePicker.delegate = self
        
        self.floatRatingView.editable = false

        currentObject = PFUser.currentUser()
        //imageImageView.frame = CGRectMake(0, 0, 100, 100)
        
        arredondarImagem()
        
        if !PFAnonymousUtils.isLinkedWithUser(currentObject) {
            println("nao anonimo")
            
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
    
    func arredondarImagem(){
        imageImageView.layer.borderWidth=1.0
        imageImageView.layer.masksToBounds = false
        imageImageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageImageView.layer.cornerRadius = imageImageView.frame.size.height/2
        imageImageView.clipsToBounds = true
    }
    
}
