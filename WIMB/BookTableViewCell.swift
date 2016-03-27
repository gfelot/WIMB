//
//  BookTableViewCell.swift
//  WIMB
//
//  Created by Gil Felot on 27/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
