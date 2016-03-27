//
//  BookViewParallaxController.swift
//  WIMB
//
//  Created by Gil Felot on 25/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse
import Gloss
import Alamofire
import PINRemoteImage

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

class BookViewParallaxController: UITableViewController, ScanBookDelegate {

    @IBOutlet var tableview: UITableView!
    
    var headerView = ParallaxHeaderView()
    let cellIdentifier = "bookCell"
    var myBook = JSON()
    var myBookFromJSON: BookFromJSON?
    var myBookFromCloud: BookFromCloud?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if myBookFromJSON == nil &&  myBookFromCloud == nil {
            performSegueWithIdentifier("scanCode", sender: nil)
        } else if myBookFromJSON != nil {
            fillFromJSON()
        } else if myBookFromCloud != nil {
            fillFromCloud()
        }
        configureTableView()
        deselectAllRows()
    }
    
    func configureTableView() {
        self.tableview.tableHeaderView = headerView
        self.tableView.estimatedRowHeight = 160.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func deselectAllRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows as [NSIndexPath]! {
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return fillMyCell(indexPath)
    }
    
    func fillMyCell(indexPath:NSIndexPath) -> BookTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! BookTableViewCell
        if indexPath.row == 0 {
            setBookTitle(cell)
        } else if indexPath.row == 1 {
            setBookAuthor(cell)
        } else if indexPath.row == 2 {
            setBookDesc(cell)
        }
        else if indexPath.row == 3 {
            setBookMark(cell)
        }
        return cell
    }
    
    func setBookTitle(cell:BookTableViewCell) {
        cell.titleLabel.text = "Titre :"
        if let title = myBook["title"] as? String {
            cell.subtitleLabel.text = title
        } else {
            cell.subtitleLabel.text = "No Title"
        }
    }
    
    func setBookAuthor(cell:BookTableViewCell) {
        cell.titleLabel.text = "Auteur :"
        if let authors = myBook["authors"] as? [String] {
            cell.subtitleLabel.text = authors.first
        } else {
            cell.subtitleLabel.text = "No Author Provided !"
        }
        
    }
    
    func setBookDesc(cell:BookTableViewCell) {
        cell.titleLabel.text = "Description :"
        if let desc = myBook["desc"] {
            cell.subtitleLabel.text = desc as? String
        } else {
            cell.subtitleLabel.text = "No Description"
        }
        
    }
    
    func setBookMark(cell:BookTableViewCell) {
        cell.titleLabel.text = "Note :"
        if let note:Double = myBook["averageRating"] as? Double{
            cell.subtitleLabel.text = note.toString()
        } else {
            cell.subtitleLabel.text = "0"
        }
        
    }


    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    func fillFromJSON() {
        if let coverString  = myBookFromJSON?.data["cover"] as! String! {
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
        myBook["title"] = myBookFromJSON?.data["title"] as? String
        myBook["authors"] = myBookFromJSON?.data["authors"] as? [String]
        myBook["desc"] = myBookFromJSON?.data["desc"] as? String
        myBook["publisher"] = myBookFromJSON?.data["publisher"] as? String
        myBook["publishedDate"] = myBookFromJSON?.data["publishedDate"] as? String
        myBook["pageCount"] = myBookFromJSON?.data["pageCount"] as? String
        myBook["categories"] = myBookFromJSON?.data["categories"] as? [String]
        myBook["averageRating"] = myBookFromJSON?.data["averageRating"] as? Double
        myBook["myNote"] = ""
        
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
        
        myBook["title"] = myBookFromCloud?.data["title"] as? String
        myBook["authors"] = myBookFromCloud?.data["authors"] as? [String]
        myBook["desc"] = myBookFromCloud?.data["desc"] as? String
        myBook["publisher"] = myBookFromCloud?.data["publisher"] as? String
        myBook["publishedDate"] = myBookFromCloud?.data["publishedDate"] as? String
        myBook["pageCount"] = myBookFromCloud?.data["pageCount"] as? String
        myBook["categories"] = myBookFromCloud?.data["categories"] as? [String]
        myBook["averageRating"] = myBookFromCloud?.data["averageRating"] as? Double
        myBook["myNote"] = myBookFromCloud?.data["myNote"] as? String
        
    }

    @IBAction func saveBookToCloud(sender: AnyObject) {
        if myBookFromJSON != nil {
            
            let book = myBookFromJSON!.prepareToCloud((headerView.headerImage.images?.first)!)
            
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
            print("Ok3")
            myBookFromJSON = bookItems.data?.first
            print(myBookFromJSON)
        }
        
    }
    
    override func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableview.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableview.tableHeaderView = header
    }
}
