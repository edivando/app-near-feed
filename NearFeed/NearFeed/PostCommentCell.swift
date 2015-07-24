
//
//  PostCommentTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/22/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell {

    @IBOutlet var postCommentCell: UIView!
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var postDate: UILabel!
    @IBOutlet var postComment: UITextView!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        postCommentCell.layer.borderColor = UIColor.lightGrayColor().CGColor
        postCommentCell.layer.borderWidth = 0.5
//        postCommentCell.layer.cornerRadius = 3
        
        userImage.layer.cornerRadius = 20
        userImage.layer.masksToBounds = true

    }

}
