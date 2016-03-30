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
import SCLAlertView

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}

class BookViewParallaxController: UITableViewController, ScanBookDelegate, EditionDelegate {

    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var headerView = ParallaxHeaderView()
    var scanAttempt = false
    let cellIdentifier = "bookCell"
    var imgView = UIImage()
    var myBook = JSON()
    var myBookFromJSON: BookFromJSON?
    var myBookFromCloud: BookFromCloud?
    var titleToEdit = String()
    var labelToEdit = String()
    var funcNb:Int = 0
    var edited = false
    var alreadyInLib = false
    var myBookID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "No_image"), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
        headerView.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(BookViewParallaxController.searchCover))
        headerView.addGestureRecognizer(gesture)
        self.tableview.tableHeaderView = self.headerView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if myBookFromJSON == nil &&  myBookFromCloud == nil && scanAttempt == false {
            performSegueWithIdentifier("scanCode", sender: nil)
        } else if (myBookFromJSON != nil) && edited == false {
            fillFromJSON()
        } else if myBookFromCloud != nil && edited == false {
            fillFromCloud()
        }
        testIfInLib()
        configureTableView()
        
    }
    
    func testIfInLib() {
        let query = PFQuery(className: "Book")
        query.whereKey("userID", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (books, error) in
            guard (books != nil) else {
                print(error)
                return
            }
            
            for book in books! {
                let _book = BookFromCloud(book: book)
                let bookId = self.myBook["id"] as? String
                if  bookId == _book.data["id"] as? String {
                    self.alreadyInLib = true
                    self.saveButton.title = "Update"
                    self.myBookID = _book.data["objectId"] as! String
                } else {
                    self.alreadyInLib = false
                    self.saveButton.title = "Save"
                }
                
            }
        }
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 160.0
        tableView.rowHeight = UITableViewAutomaticDimension
        deselectAllRows()
        tableview.reloadData()
    }
    
    func deselectAllRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows as [NSIndexPath]! {
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return fillMyCell(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! BookTableViewCell
        titleToEdit = currentCell.titleLabel.text!
        labelToEdit = currentCell.subtitleLabel.text!
        funcNb = indexPath.row
        performSegueWithIdentifier("editRow", sender: nil)
        
    }
    
    
    func fillMyCell(indexPath:NSIndexPath) -> BookTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! BookTableViewCell
        if indexPath.row == 0 {
            setBookTitle(cell)
        } else if indexPath.row == 1 {
            setBookAuthor(cell)
        }else if indexPath.row == 2 {
            setBookDesc(cell)
        }else if indexPath.row == 3 {
            setBookPuslisher(cell)
        }else if indexPath.row == 4 {
            setBookPuslishedDate(cell)
        }else if indexPath.row == 5 {
            setBookCategories(cell)
        }else if indexPath.row == 6 {
            setBookPage(cell)
        }else if indexPath.row == 7 {
            setBookMark(cell)
        }else if indexPath.row == 8 {
            setBookMyNote(cell)
        }
        return cell
    }
    
    func setBookTitle(cell:BookTableViewCell) {
        cell.titleLabel.text = "Title :"
        if let title = myBook["title"] as? String {
            cell.subtitleLabel.text = title
        } else {
            cell.subtitleLabel.text = "No Title"
        }
    }
    
    func setBookAuthor(cell:BookTableViewCell) {
        cell.titleLabel.text = "Authors :"
        if let authors = myBook["authors"] as? [String] {
            cell.subtitleLabel.text = authors.first
        } else {
            cell.subtitleLabel.text = "No Author Provided !"
        }
        
    }
    
    func setBookPuslisher(cell:BookTableViewCell) {
        cell.titleLabel.text = "Publisher :"
        if let publisher = myBook["publisher"] as? String{
            cell.subtitleLabel.text = publisher
        } else {
            cell.subtitleLabel.text = "No info"
        }
        
    }
    
    func setBookPuslishedDate(cell:BookTableViewCell) {
        cell.titleLabel.text = "Published Date :"
        if let publishedDate = myBook["publishedDate"] as? String {
            cell.subtitleLabel.text = publishedDate
        } else {
            cell.subtitleLabel.text = "No info"
        }
        
    }
    
    func setBookDesc(cell:BookTableViewCell) {
        cell.titleLabel.text = "Description :"
        if let desc = myBook["desc"] as? String {
            cell.subtitleLabel.text = desc
        } else {
            cell.subtitleLabel.text = "No Description"
        }
        
    }
    
    func setBookMark(cell:BookTableViewCell) {
        cell.titleLabel.text = "Mark :"
        if let note:Double = myBook["averageRating"] as? Double{
            cell.subtitleLabel.text = note.toString()
        } else {
            cell.subtitleLabel.text = "0"
        }
        
    }
    
    func setBookPage(cell:BookTableViewCell) {
        cell.titleLabel.text = "Page :"
        var myPage = myBook["pageWhereAmI"] as? String
        if myPage == nil {
            myPage = "0"
        }
        cell.subtitleLabel.text = "\(myPage!)"
    }
    
    func setBookCategories(cell:BookTableViewCell) {
        cell.titleLabel.text = "Categories :"
        if let categories = myBook["categories"] as? [String] {
            var tmp = String()
            for cat in categories {
                tmp = "- \(cat)\n"
            }
            cell.subtitleLabel.text = tmp
        } else {
            cell.subtitleLabel.text = "- No categories"
        }
        
    }
    
    func setBookMyNote(cell:BookTableViewCell) {
        cell.titleLabel.text = "My Notes :"
        if let myNote = myBook["myNote"] as? String{
            cell.subtitleLabel.text = myNote
        } else {
            cell.subtitleLabel.text = "No personal notes on this book"
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Set book view controller as delegate to scan book view controller
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        } else if segue.identifier == "editRow" {
            let vc = segue.destinationViewController as! EditionViewController
            vc.myTitleString = titleToEdit
            vc.myEditTextString = labelToEdit
            vc.myFuncNB = funcNb
            vc.delegate = self
        }
    }
    
    func fillFromJSON(){
        if let coverString  = myBookFromJSON?.data["cover"] as! String! {
            if let url = NSURL(string: coverString) {
                let imageView = UIImageView()
                imageView.pin_setImageFromURL(url, completion: { (PINRemoteImageManagerResult) in
                    self.headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(imageView.image, forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
                    self.tableview.tableHeaderView = self.headerView
                })
            }
        } else {
            imgView = UIImage(named: "No_image")!
            headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "No_image"), forSize: CGSizeMake(self.tableview.frame.size.height, 300)) as! ParallaxHeaderView
            self.tableview.tableHeaderView = self.headerView
        }
        myBook["objectId"] = myBookFromJSON?.data["objectId"] as? String
        myBook["id"] = myBookFromJSON?.data["id"] as? String
        myBook["title"] = myBookFromJSON?.data["title"] as? String
        myBook["authors"] = myBookFromJSON?.data["authors"] as? [String]
        myBook["desc"] = myBookFromJSON?.data["desc"] as? String
        myBook["publisher"] = myBookFromJSON?.data["publisher"] as? String
        myBook["publishedDate"] = myBookFromJSON?.data["publishedDate"] as? String
        myBook["pageWhereAmI"] = "0"
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
        myBook["objectId"] = myBookFromCloud?.data["objectId"] as? String
        myBook["id"] = myBookFromCloud?.data["id"] as? String
        myBook["title"] = myBookFromCloud?.data["title"] as? String
        myBook["authors"] = myBookFromCloud?.data["authors"] as? [String]
        myBook["desc"] = myBookFromCloud?.data["desc"] as? String
        myBook["publisher"] = myBookFromCloud?.data["publisher"] as? String
        myBook["publishedDate"] = myBookFromCloud?.data["publishedDate"] as? String
        myBook["pageWhereAmI"] = myBookFromCloud?.data["pageWhereAmI"] as? String
        myBook["pageCount"] = myBookFromCloud?.data["pageCount"] as? String
        myBook["categories"] = myBookFromCloud?.data["categories"] as? [String]
        myBook["averageRating"] = myBookFromCloud?.data["averageRating"] as? Double
        myBook["myNote"] = myBookFromCloud?.data["myNote"] as? String
    }

    @IBAction func saveBookToCloud(sender: AnyObject) {
        let myBook = prepareToCloud(headerView.headerImage)
        
        if alreadyInLib == false {
            //Save if new
            myBook.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    let alertView = SCLAlertView()
                    alertView.addButton("Yey !") {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alertView.showCloseButton = false
                    alertView.showSuccess("Book Saved", subTitle: "It's in the Cloud now")
                } else {
                    print(error!)
                }
            }
        } else {
            //Update object
            let query = PFQuery(className: "Book")
            query.whereKey("id", equalTo: myBook["id"])
            query.findObjectsInBackgroundWithBlock({ (books, error) in
                if error != nil {
                    print(error)
                } else {
                    let book = books?.first
                    book!["id"] = myBook["id"] as? String
                    book!["title"] = myBook["title"] as? String
                    book!["authors"] = myBook["authors"] as? [String]
                    book!["desc"] = myBook["desc"] as? String
                    book!["publisher"] = myBook["publisher"] as? String
                    book!["publishedDate"] = myBook["publishedDate"] as? String
                    book!["pageWhereAmI"] = myBook["pageWhereAmI"] as? String
                    book!["pageCount"] = myBook["pageCount"] as? String
                    book!["categories"] = myBook["categories"] as? [String]
                    book!["averageRating"] = myBook["averageRating"] as? Double
                    book!["myNote"] = myBook["myNote"] as? String
                    book?.saveInBackground()
                }
            })
//            query.getObjectInBackgroundWithId(myBookID, block: { (book, error) in
//                if error != nil {
//                    print(error)
//                } else {
//                    book!["id"] = myBook["id"] as? String
//                    book!["title"] = myBook["title"] as? String
//                    book!["authors"] = myBook["authors"] as? [String]
//                    book!["desc"] = myBook["desc"] as? String
//                    book!["publisher"] = myBook["publisher"] as? String
//                    book!["publishedDate"] = myBook["publishedDate"] as? String
//                    book!["pageWhereAmI"] = myBook["pageWhereAmI"] as? String
//                    book!["pageCount"] = myBook["pageCount"] as? String
//                    book!["categories"] = myBook["categories"] as? [String]
//                    book!["averageRating"] = myBook["averageRating"] as? Double
//                    book!["myNote"] = myBook["myNote"] as? String
//                    book?.saveInBackground()
//                }
//            })
            
            let alertView = SCLAlertView()
            alertView.addButton("Yey !") {
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.showCloseButton = false
            alertView.showSuccess("Book Updated", subTitle: "It's still in the Cloud now")
        }
        
        
    }
    
    func prepareToCloud(image:UIImage) -> PFObject {
        let book = PFObject(className: "Book")
        book["userID"] = PFUser.currentUser()?.objectId
        let imageData: NSData = UIImagePNGRepresentation(image)!
        let imageFile = PFFile(name: "cover.png", data: imageData)
        book["coverFile"] = imageFile
        
        for (key, value) in myBook {
            book[key] = value
        }
        return book
    }
    
    override func  scrollViewDidScroll(scrollView: UIScrollView) {
        let header: ParallaxHeaderView = self.tableview.tableHeaderView as! ParallaxHeaderView
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
        self.tableview.tableHeaderView = header
    }
    
    func didScanBook(scannedBook:BookItems!)
    {
        let bookItems: BookItems! = scannedBook
        if bookItems.data?.first != nil {
            myBookFromJSON = bookItems.data?.first
        } else {
            let alertView = SCLAlertView()
            alertView.addButton("Go Back") {
                self.navigationController?.popViewControllerAnimated(true)
                self.scanAttempt = true

            }
            alertView.showCloseButton = false
            alertView.showError("This ISNB code isn't avaible", subTitle: "Nothing found in the database")
        }
        
    }
    
    func getEdit(textEdited: String, funcNb: Int) {
        if funcNb == 0 {
           myBook["title"] = textEdited
        } else if funcNb == 1 {
            let array = textEdited.characters.split{$0 == "\n"}.map(String.init)
            myBook["authors"] = array // [String]
        } else if funcNb == 2 {
            myBook["desc"] = textEdited
        } else if funcNb == 3 {
            myBook["publisher"] = textEdited
        } else if funcNb == 4 {
            myBook["publishedDate"] = textEdited
        } else if funcNb == 5 {
            let array = textEdited.characters.split{$0 == "\n"}.map(String.init)
            myBook["categories"] = array // [String]
        } else if funcNb == 6 {
            myBook["pageWhereAmI"] = textEdited
        } else if funcNb == 7 {
            myBook["averageRating"] = textEdited // Double
        } else if funcNb == 8 {
            myBook["myNote"] = textEdited
        }
        edited = true
        
    }
    
    func searchCover() {
        print("Oh tu m'as touché coquin !")
    }
    
}
