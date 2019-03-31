//
//  NewsArticleTableViewCell.swift
//  NYTimes
//
//  Created by Sen Abraham on 3/31/19.
//  Copyright © 2019 Sen Abraham. All rights reserved.
//

import UIKit

class NewsArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var aritcleNameLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
