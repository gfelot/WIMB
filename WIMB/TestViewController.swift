//
//  TestViewController.swift
//  WIMB
//
//  Created by Gil Felot on 24/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img1.image = UIImage(named: "bg")
        img2.image = UIImage(named: "bg")
        
        img2.makeBlurImage(img1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
