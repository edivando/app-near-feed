//
//  PostViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImage]()
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        for index in 0..<images.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = images[index]
            //subView.backgroundColor = UIColor.redColor()
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(images.count), self.scrollView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        images.append(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cameraPhoto(){
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func libraryPhoto(){
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func locationChange(sender: AnyObject) {
        //Para o usuario escolher se quer postar na localizacao atual dele, ou a localizacao que ele mora
    }

    @IBAction func addImage(sender: AnyObject) {
        var alert = UIAlertController(title: "Image from:", message: nil, preferredStyle: .ActionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            self.cameraPhoto()
        }
        var libraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action) -> Void in
            self.libraryPhoto()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        Post().newPost(textView.text, images: images) { (error) -> () in
            if error == nil{
                println("ok")
            }
        }
        textView.text = ""
        images = [UIImage]()
    }
    
}
