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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
