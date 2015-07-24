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
    var currentUser : User?
    var imageFile: PFFile?
    let imagePicker = UIImagePickerController()
    var email : String?
    var maxScore : Int?
    
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
        
        
        imagePicker.delegate = self
        
        self.floatRatingView.editable = false

        currentUser = User.currentUser()
        //imageImageView.frame = CGRectMake(0, 0, 100, 100)
        
        arredondarImagem()
        
        config()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        config()
    }
    
    func config() {
        
        if !PFAnonymousUtils.isLinkedWithUser(currentUser) {
            println("nao anonimo")
            
            //if let object = currentObject {
            editButton.enabled = true
            signUpButton.hidden = true
            emailLabel.text = currentUser!["email"] as? String
            nameLabel.text = currentUser!["name"] as? String
            
            let number = currentUser!["score"] as? NSNumber
            
            
            User.findFirstUserByScore { (user) -> () in
                
                if let user = user {
                    self.maxScore = Int(user.score)
                } else {
                    self.maxScore = Int(self.currentUser!.score)
                }
                
                if let num = number {
                    self.pontuacaoLabel.text = String(stringInterpolationSegment: number!)
                    self.floatRatingView.rating = Float(Int(Float(num) / Float(self.maxScore!) * 5.0))
                } else {
                    self.pontuacaoLabel.text = String(0)
                }
                
              }
            
            if let user = currentUser{
                
                    self.imageImageView.image = UIImage(named: "user")
                    user.image.image({ (image) -> () in
                    
                    if let image = image{
                        
                        self.imageImageView.image = image
                    }
                })
            
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
