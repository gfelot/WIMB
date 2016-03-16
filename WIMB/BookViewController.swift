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
    
    var myBook:Book!
    
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
            downloadImage((myBook.coverURL)!)
            bookTitle.text = myBook.title
            authors.text = myBook.authors.first
            desc.text = myBook.desc
            pageCount.text = String(myBook.pageCount)
            
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

    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    @IBAction func saveBookToCloud(sender: AnyObject) {
        if myBook != nil {
            let book = PFObject(className: "Book")
            book["id"] = myBook.id
            book["selfLink"] = myBook.selfLinkString
            book["coverURL"] = myBook.coverURLString
            book["title"] = myBook.title
            book["authors"] = myBook.authors
//            book["isbn"] = myBook.isbn
            book["desc"] = myBook.desc
            book["publisher"] = myBook.publisher
            book["publishedDate"] = myBook.publishedDate
            book["pageCount"] = myBook.pageCount
            book["language"] = myBook.language
            book["categories"] = myBook.categories
            book["averageRating"] = myBook.averageRating
            book["previewLink"] = myBook.previewLinkString
            
            book.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("Sucess")
                } else {
                    print(error!)
                }
            }
        
        }
    }
    
    
    func didScanBook(scannedBook:BookItems!)
    {
        
        let bookItems: BookItems! = scannedBook
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
