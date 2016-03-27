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

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

class BookViewParallaxController: UITableViewController, ScanBookDelegate {

    @IBOutlet var tableview: UITableView!
    
    var headerView = ParallaxHeaderView()
    let cellIdentifier = "bookCell"
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
        configureTableView()
        
    }
    
    func configureTableView() {
        self.tableview.tableHeaderView = headerView
        self.tableView.estimatedRowHeight = 160.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
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
        if let title = myBookFromCloud?.data["title"] as? String {
            cell.subtitleLabel.text = title
        } else {
            cell.subtitleLabel.text = "No Title"
        }
    }
    
    func setBookAuthor(cell:BookTableViewCell) {
        cell.titleLabel.text = "Auteur :"
        if let authors = myBookFromCloud?.data["authors"] as? [String] {
            cell.subtitleLabel.text = authors.first
        } else {
            cell.subtitleLabel.text = "No Author Provided !"
        }
        
    }
    
    func setBookDesc(cell:BookTableViewCell) {
        cell.titleLabel.text = "Description :"
        if let desc = myBookFromCloud?.data["desc"] {
            cell.subtitleLabel.text = desc as? String
        } else {
            cell.subtitleLabel.text = "No Description"
        }
        
    }
    
    func setBookMark(cell:BookTableViewCell) {
        cell.titleLabel.text = "Note :"
        if let note:Double = myBookFromCloud?.data["averageRating"] as? Double{
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
