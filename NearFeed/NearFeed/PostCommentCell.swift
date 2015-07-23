
//
//  PostCommentTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/22/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var postDate: UILabel!
    @IBOutlet var postComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
