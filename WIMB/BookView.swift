//
//  BookView.swift
//  WIMB
//
//  Created by Gil Felot on 22/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

@IBDesignable class BookView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var scrollBook: UIScrollView!
    @IBOutlet weak var titleBook: UILabel!
    @IBOutlet weak var authorsBook: UILabel!
    @IBOutlet weak var descBook: UILabel!
    @IBOutlet weak var backgroudImage: UIImageView!
    
    let nibName: String = "BookView"
    
    override init(frame: CGRect) {
        // properties
        super.init(frame: frame)
        
        // Set anything that uses the view or visible bounds
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)
        
        // Setup
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
}
