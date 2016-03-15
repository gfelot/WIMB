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

class BookViewController: UIViewController, ScanBookDelegate {
    
    var bookItems:BookItems!
    
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
//        scrollView.contentSize.width = width
        scrollView.contentSize.height = 4000
        if bookItems == nil {
            performSegueWithIdentifier("scanCode", sender: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if bookItems != nil {
            downloadImage((bookItems.data?.first?.coverURL)!)
            bookTitle.text = bookItems.data?.first?.title
            authors.text = bookItems.data?.first?.authors.first
            desc.text = bookItems.data?.first?.desc
            pageCount.text = String(bookItems.data?.first?.pageCount)
            
            bookTitle.numberOfLines = 0
            bookTitle.sizeToFit()
            authors.numberOfLines = 0
            authors.sizeToFit()
            desc.numberOfLines = 0
            desc.sizeToFit()
            pageCount.numberOfLines = 0
            pageCount.sizeToFit()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if bookItems != nil {
//            downloadImage((bookItems.data?.first?.coverURL)!)
//            bookTitle.text = bookItems.data?.first?.title
//            authors.text = bookItems.data?.first?.authors.first
//            desc.text = bookItems.data?.first?.desc
//            pageCount.text = String(bookItems.data?.first?.pageCount)
//            
//            bookTitle.numberOfLines = 0
//            bookTitle.sizeToFit()
//            authors.numberOfLines = 0
//            authors.sizeToFit()
//            desc.numberOfLines = 0
//            desc.sizeToFit()
//            pageCount.numberOfLines = 0
//            pageCount.sizeToFit()
//        }
    }

    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    func didScanBook(scannedBook:BookItems!)
    {
        self.bookItems = scannedBook
        
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
