//
//  ArticleTableViewCell.swift
//  collegian-app
//
//  Created by Camille Santos on 4/28/16.
//  Copyright © 2016 Camille Santos. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
