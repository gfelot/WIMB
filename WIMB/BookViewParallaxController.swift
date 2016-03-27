//
//  BookViewParallaxController.swift
//  WIMB
//
//  Created by Gil Felot on 25/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import PINRemoteImage


class BookViewParallaxController: UITableViewController, ScanBookDelegate {

    @IBOutlet var tableview: UITableView!
    
    var headerView = ParallaxHeaderView()
    
    var myBook: BookFromJSON?
    var myBookFromCloud: BookFromCloud?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myBook == nil &&  myBookFromCloud == nil{
            performSegueWithIdentifier("scanCode", sender: nil)
        }
        if myBook != nil {
            fillFromAPI()
        } else if myBookFromCloud != nil {
            fillFromCloud()
        }
        self.tableview.tableHeaderView = headerView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    func fillFromAPI() {
        if let coverString  = myBook?.data["cover"] as! String! {
            if let url = NSURL(string: coverString) {
                let imgView = UIImageView()
                imgView.pin_setImageFromURL(url)
                headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(imgView.image, forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
                self.tableview.tableHeaderView = headerView
                
            } else {
                
                headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "No_image"), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
            }
        } else {
            headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "No_image"), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
        }
        
    }
    
    func fillFromCloud() {
        let imageFile = myBookFromCloud?.data["coverFile"]
        imageFile?.getDataInBackgroundWithBlock({ (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(data: imageData), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
                    self.tableview.tableHeaderView = self.headerView
                    
                }
            }
        })
        
    }
    

    @IBAction func saveBookToCloud(sender: AnyObject) {
        print("Test")
        if myBook != nil {
            
            let book = myBook!.prepareToCloud((headerView.headerImage.images?.first)!)
            
            print(book)
            
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
    
    override func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableview.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableview.tableHeaderView = header
    }
}
