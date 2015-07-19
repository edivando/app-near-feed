//
//  PostTableViewCell.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var postLocality: UILabel!
    @IBOutlet var postText: UITextView!
    @IBOutlet var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
