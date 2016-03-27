//
//  BookViewController.swift
//  WIMB
//
//  Created by Gil Felot on 10/01/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import PINRemoteImage

//extension UIImageView{
//    
//    func makeBlurImage(targetImageView:UIImageView?)
//    {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = targetImageView!.bounds
//        
//        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
//        targetImageView?.addSubview(blurEffectView)
//    }
//    
//}

class BookViewController: UIViewController, ScanBookDelegate {
    
    var myBook: BookFromJSON?
    var myBookFromCloud: BookFromCloud?
    
    @IBOutlet weak var myView: BookView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if myBook == nil &&  myBookFromCloud == nil{
            performSegueWithIdentifier("scanCode", sender: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if myBook != nil {
            fillFromAPI()
        } else if myBookFromCloud != nil {
            fillFromCloud()
        }
        
    }

    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    @IBAction func saveBookToCloud(sender: AnyObject) {
        if myBook != nil {
            
            let book = myBook!.prepareToCloud(myView.bookImage.image!)
            
            book.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.alertPopUp("Book Saved", message: "It's in the Cloud now")
                } else {
                    print(error!)
                }
            }
        
        }
    }
    
    func fillFromAPI() {
        if let coverString  = myBook?.data["cover"] as! String! {
            if let url = NSURL(string: coverString) {
                myView.bookImage.pin_setImageFromURL(url)
            } else {
                myView.bookImage.image = UIImage(named: "No_image")
            }
        } else {
            myView.bookImage.image = UIImage(named: "No_image")
        }
        
        
        if let _title = myBook?.data["title"] as! String! {
            myView.titleBook.text = _title
        } else {
            myView.titleBook.text = "No Title"
        }
        myView.titleBook.numberOfLines = 0
        myView.titleBook.sizeToFit()
        
        if let _author = myBook!.data["authors"] as! [String]? {
            myView.authorsBook.text = _author.first
        }else{
            myView.authorsBook.text = "No Author"
        }
        myView.authorsBook.numberOfLines = 0
        myView.authorsBook.sizeToFit()
        
        if let _desc = myBook?.data["desc"] as! String! {
            myView.descBook.text = _desc
        }else {
            myView.descBook.text = "No Description"
        }
        myView.descBook.numberOfLines = 0
        myView.descBook.sizeToFit()
    }
    
    func fillFromCloud() {
        let imageFile = myBookFromCloud?.data["coverFile"]
        imageFile?.getDataInBackgroundWithBlock({ (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.myView.bookImage.image = UIImage(data: imageData)
                }
            }
        })
        
        if let _title = myBookFromCloud?.data["title"] as! String! {
            myView.titleBook.text = _title
        } else {
            myView.titleBook.text = "No Title"
        }
        myView.titleBook.numberOfLines = 0
        myView.titleBook.sizeToFit()
        
        if let _author = myBookFromCloud!.data["authors"] as! [String]? {
            myView.authorsBook.text = _author.first
        }else{
            myView.authorsBook.text = "No Author"
        }
        myView.authorsBook.numberOfLines = 0
        myView.authorsBook.sizeToFit()
        
        if let _desc = myBookFromCloud?.data["desc"] as! String! {
            myView.descBook.text = _desc
        }else {
            myView.descBook.text = "No Description"
        }
        myView.descBook.numberOfLines = 0
        myView.descBook.sizeToFit()
        
        
    }
    
    func alertPopUp(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func didScanBook(scannedBook:BookItems!)
    {
        let bookItems: BookItems! = scannedBook
        if bookItems != nil {
            myBook = bookItems.data?.first
        }
        
    }
}
