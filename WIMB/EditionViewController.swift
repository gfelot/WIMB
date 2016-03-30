//
//  EditionViewController.swift
//  WIMB
//
//  Created by Gil Felot on 29/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

protocol EditionDelegate {
    func getEdit(textEdited:String, funcNb:Int)
}


class EditionViewController: UIViewController {

    var myTitleString = String()
    var myEditTextString = String()
    var myFuncNB = Int()
    var delegate: EditionDelegate? = nil
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var edit: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = myTitleString
        edit.text = myEditTextString
        // Do any additional setup after loading the view.
    }


    @IBAction func saveEdition(sender: AnyObject) {
        if (delegate != nil) {
            delegate!.getEdit(edit.text!, funcNb: myFuncNB)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            print("toto")
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
