//
//  CommentPopoverTableViewCell.swift
//  NearFeed
//
//  Created by Yuri Reis on 19/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class CommentPopoverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet var userComment: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = 20
        userImage.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
