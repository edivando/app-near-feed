//
//  ProfileViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate  {
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var imageImageView: UIImageView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var pontuacaoLabel: UILabel!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.floatRatingView.editable = false
        imageImageView.toRound()
        
        if let currentUser = User.currentUser(){
            if PFAnonymousUtils.isLinkedWithUser(currentUser) {
                editButton.enabled = false
                performSegueWithIdentifier("segueSignUp", sender: nil)
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentUser = User.currentUser(){
            if !PFAnonymousUtils.isLinkedWithUser(currentUser) {
                editButton.enabled = true
                
                emailLabel.text = currentUser.email
                nameLabel.text = currentUser.name
                pontuacaoLabel.text = String(stringInterpolationSegment: currentUser.score)
                
                User.findFirstUserByScore { (user) -> () in
                    
                    if let user = user {
                        self.floatRatingView.rating = Float(Int(currentUser.score.floatValue / user.score.floatValue * 5.0))
                    } else {
                        self.floatRatingView.rating = Float(Int(currentUser.score.floatValue / currentUser.score.floatValue * 5.0))
                    }
                }
                currentUser.image.image({ (image) -> () in
                    if let image = image{
                        self.imageImageView.image = image
                    }
                })
            }
        }
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        performSegueWithIdentifier("segueSignUp", sender: nil)
    }
    
}
