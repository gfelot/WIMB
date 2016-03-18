//
//  ParallaxCollectionViewCell.swift
//  WIMB
//
//  Created by Gil Felot on 17/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

let ImageHeight: CGFloat = 200.0
let OffsetSpeed: CGFloat = 25.0

class ParallaxCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage = UIImage() {
        didSet {
        imageView.image = image
        }
    }
    
    func offset(offset: CGPoint) {
        imageView.frame = CGRectOffset(self.imageView.bounds, offset.x, offset.y)
    }

}
