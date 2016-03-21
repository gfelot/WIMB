//
//  ParallaxTableViewCell
//  WIMB
//
//  Created by Gil Felot on 17/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

let ImageHeight: CGFloat = 200.0
let OffsetSpeed: CGFloat = 25.0

class ParallaxTableViewCell: UITableViewCell {
    

    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var cellTop: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        imageBook.contentMode = .ScaleAspectFill
        imageBook.clipsToBounds = false
    }


}
