//
//  PostViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, MBProgressHUDDelegate {
   
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet var btAddImage: UIBarButtonItem!
    @IBOutlet weak var userLocation: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images = [UIImage]()
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    let picker = UIImagePickerController()
    
    private var progress = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPage = 0
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        scrollView.delegate = self
        
        btAddImage.tintColor = Color.blue

        userLocation.enabled = false
        textView.delegate = self
        textView.text = "Type your post here..."
        textView.textColor = UIColor.lightGrayColor()
        textView.becomeFirstResponder()
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
        self.view.addGestureRecognizer(tapGesture)
        
        configProgress()
    }
    
    func configProgress(){
        progress = MBProgressHUD(view: view)
        view.addSubview(progress)
        progress.labelText = "Saving..."
        progress.dimBackground = true
        progress.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        userLocation.title = "\(UserLocation.countryName) / \(UserLocation.cityName) / \(UserLocation.regionName)"
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ScrollView
    
    func refreshScrollView(){
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
    
            var subView = UIImageView(frame: frame)
            subView.image = images[index]
    
            //subView.contentMode = UIViewContentMode.ScaleAspectFit
            var longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
            
            subView.addGestureRecognizer(longPressGesture)
            subView.userInteractionEnabled = true
            
            
            self.scrollView.addSubview(subView)
        }
        scrollView.contentInset = UIEdgeInsetsZero
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(images.count), scrollView.frame.size.height)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth = self.scrollView.frame.size.width
        var fractionalPage = Double(self.scrollView.contentOffset.x / pageWidth)
        var page = lround(fractionalPage)
        self.pageControl.currentPage = page;
    }
    
    //MARK: - Gestures
    
    func handleTap(){
        self.view.endEditing(true)
    }
    
    func handleLongPress(recognizer : UILongPressGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.Began{
            var alert = UIAlertController(title: "Image", message: nil, preferredStyle: .ActionSheet)
            var deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
                self.removeImagesFromScrollView()
                var imageView = recognizer.view as! UIImageView
                var index = find(self.images, imageView.image!)
                if let index = index{
                    self.images.removeAtIndex(index)
                }
                self.refreshScrollView()
                Message.info("Image removed", text: "")
            }
            var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
    
    func removeImagesFromScrollView(){
        for subview in scrollView.subviews{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                subview.removeFromSuperview()
            })
        }
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
        
        var rawString = textView.text
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet
        var trimmed = rawString.stringByTrimmingCharactersInSet(whitespace())
        
        if (count(trimmed) == 0 || textView.text == "Type your post here...") && images.count == 0{
            Message.info("Post empty", text: "Add an image or some text to your post")
        }
        else{
            view.endEditing(true)
            navigationItem.leftBarButtonItem?.enabled = false
            navigationItem.rightBarButtonItem?.enabled = false
            progress.show(true)
            Post().newPost(textView.text, images: images) { (error) -> () in
                if error == nil{
                    println("ok")
                    Message.success("Post sent", text: "")
                    self.textView.text = "Type your post here..."
                    self.textView.textColor = UIColor.lightGrayColor()
                    self.images = [UIImage]()
                    self.removeImagesFromScrollView()
                    self.refreshScrollView()
                    self.navigationItem.leftBarButtonItem?.enabled = true
                    self.navigationItem.rightBarButtonItem?.enabled = true
                }
                else{
                    if error?.code == 01{
                        Message.error("User not logged in", text: "Please, login before posting")
                    }else if error?.code == 02{
                        
                        Alert.userAnonymous(self)
                        self.navigationItem.leftBarButtonItem?.enabled = true
                        self.navigationItem.rightBarButtonItem?.enabled = true
                        println("error \(error?.domain)")
                        
                    }
                }
                self.progress.hide(true)
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        textView.text = "Type your post here..."
        textView.textColor = UIColor.lightGrayColor()
        images = [UIImage]()
        removeImagesFromScrollView()
        self.view.endEditing(true)
        Message.info("Canceled", text: "")
    }
    
}
