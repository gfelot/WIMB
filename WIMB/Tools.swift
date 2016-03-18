//
//  Tools.swift
//  WIMB
//
//  Created by Gil Felot on 16/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import Foundation
import UIKit

class Tools {
    
    internal func httpsConverter(str:String!) -> String? {
        var tmp = str
        if str != nil {
            if tmp.hasPrefix("http://") {
                tmp.removeRange(Range<String.Index>(str.startIndex ..< str.startIndex.advancedBy(7)))
                tmp.insertContentsOf("https://".characters, at: str.startIndex)
            }
            return tmp
        } else {
            return nil
        }
    }
    
}
