//
//  PostViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var images = [UIImage]()
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "Type your post here..."
        textView.textColor = UIColor.lightGrayColor()
        textView.becomeFirstResponder()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        for index in 0..<images.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = images[index]
            subView.contentMode = UIViewContentMode.ScaleAspectFit
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(images.count), self.scrollView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Gestures
    
    func handleTap(){
        self.view.endEditing(true)
    }
    
    //MARK: - TextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Type your post here..." {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == ""{
            textView.text = "Type your post here..."
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    
    //MARK: - ImagePicker
    
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
    
    //MARK: - Actions
    
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
        textView.text = "Type your post here..."
        textView.textColor = UIColor.lightGrayColor()
        images = [UIImage]()
        for subview in scrollView.subviews{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                subview.removeFromSuperview()
            })
        }
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        textView.text = "Type your post here..."
        textView.textColor = UIColor.lightGrayColor()
        images = [UIImage]()
        
        for subview in scrollView.subviews{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                subview.removeFromSuperview()
            })
        }
        self.view.endEditing(true)
    }
    
}
