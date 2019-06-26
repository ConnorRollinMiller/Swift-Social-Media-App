//
//  FeedTableViewCell.swift
//  InstagramClone
//
//  Created by Connor Miller on 11/26/18.
//  Copyright © 2018 Connor Miller. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
