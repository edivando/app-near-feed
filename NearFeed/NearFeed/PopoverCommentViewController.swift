//
//  PopoverCommentViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 17/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class PopoverCommentViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var post:Post?
    var comments:[PostComment]!
    
    //MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
//        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        updateComments()
    }
    
    //MARK: - TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        checkIfEmptyAndSend()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var defaultCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        var defaultCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: Selector("keyboardDidHide:"), name: UIKeyboardDidHideNotification, object: nil)
        self.view.endEditing(true)
        return true
    }
    
    //MARK: - Adjust popover view
    
    func keyboardDidShow(notification: NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardSize.height, self.view.frame.width, self.view.frame.height)
        }
    }
    
    func keyboardDidHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardSize.height, self.view.frame.width, self.view.frame.height)
        
        }
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var comment = comments[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as? CommentPopoverTableViewCell{
            comment.objectForKey("user")?.fetchIfNeededInBackgroundWithBlock({ (object, error) -> Void in
                if let user = object as? User{
                    cell.userName.text = user.name
                    user.image.image({ (image) -> () in
                        if let img = image{
                            cell.userImage.image = img
                        }
                    })
                }
            })
            cell.commentDate.text = comment.createdAt?.dateFormat()
            cell.userComment.text = comment.message
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - Actions
    
    @IBAction func send(sender: AnyObject) {
        checkIfEmptyAndSend()
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Helper
    
    func checkIfEmptyAndSend(){
        var rawString = textField.text
        var whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet
        var trimmed = rawString.stringByTrimmingCharactersInSet(whitespace())
        
        if count(trimmed) == 0{
            Message.info("Comment empty", text: "")
        }
        else{
            if let post = post{
                post.addComment(textField.text, error: { (error) -> () in
                    
                    Alert.userAnonymous(self)
                    println("Error \(error)")
                    
                })
            }
            textField.text = ""
            view.endEditing(true)
            updateComments()
        }
    }
    func updateComments(){
        if let comments = post?.comments{
            self.comments = comments
            self.tableView.reloadData()
        }
    }

}
