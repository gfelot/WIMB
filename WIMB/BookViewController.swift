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

class BookViewController: UIViewController, ScanBookDelegate {
    
    var myBook:Book?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bookImage: UIImageView!
    

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var pageCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let bounds = UIScreen.mainScreen().bounds
//        let width = bounds.size.width
        scrollView.contentSize.width = 300
        scrollView.contentSize.height = 4000000
        if myBook == nil {
            performSegueWithIdentifier("scanCode", sender: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if myBook != nil {
            
            if let coverString  = myBook?.data["cover"] as! String! {
                if let url = NSURL(string: coverString) {
                    bookImage.pin_setImageFromURL(url)
                }
            }

            
            if let _title = myBook?.data["title"] as! String! {
                bookTitle.text = _title
            }else {
                bookTitle.text = "No Title"
            }
            bookTitle.numberOfLines = 0
            bookTitle.sizeToFit()
            
            if let _author = myBook!.data["authors"] as! [String]? {
                authors.text = _author.first
            }else{
                authors.text = "No Author"
            }
            authors.numberOfLines = 0
            authors.sizeToFit()
            
            if let _desc = myBook?.data["desc"] as! String! {
                desc.text = _desc
            }else {
                desc.text = "No Description"
            }
            desc.numberOfLines = 0
            desc.sizeToFit()
            
            if let _pageCount = myBook!.data["pageCount"] as! String! {
                pageCount.text = String(_pageCount)
            } else {
                pageCount.text = "No Page Count"
            }
            pageCount.numberOfLines = 0
            pageCount.sizeToFit()
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
            
            
            let book = myBook!.prepareToCloud()
            
            book.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("Book Save in Cloud")
                } else {
                    print(error!)
                }
            }
        
        }
    }
    
    
    func didScanBook(scannedBook:BookItems!)
    {
        let bookItems: BookItems! = scannedBook
        print(bookItems.data?.first)
        if bookItems != nil {
            myBook = bookItems.data?.first
        }
        
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.bookImage.image = UIImage(data: data)
            }
        }
    }

}
