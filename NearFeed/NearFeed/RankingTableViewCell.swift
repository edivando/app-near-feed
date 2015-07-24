//
//  RankingTableViewCell.swift
//  NearFeed
//
//  Created by Alisson Carvalho on 23/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var floatRatingView: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageview.layer.borderWidth=1.0
        imageview.layer.masksToBounds = false
        imageview.layer.borderColor = UIColor.whiteColor().CGColor
        imageview.layer.cornerRadius = imageview.frame.size.height/2
        imageview.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
