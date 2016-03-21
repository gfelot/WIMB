//
//  LibraryTableViewController.swift
//  WIMB
//
//  Created by Gil Felot on 18/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse



class LibraryTableViewController: UITableViewController {

    let parallaxCellIdentifier = "parallaxCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgBook: UIImageView!
    
    var bookImages = [String?]()
    var bookTitle = [String?]()
    var objectID = [String?]()
    
    // Change the ratio or enter a fixed value, whatever you need
    var cellHeight: CGFloat {
        return tableView.frame.width * 9 / 16
    }
    
    // Just an alias to make the code easier to read
    var imageVisibleHeight: CGFloat {
        return cellHeight
    }
    
    // Change this value to whatever you like (it sets how "fast" the image moves when you scroll)
    let parallaxOffsetSpeed: CGFloat = 25
    
    // This just makes sure that whatever the design is, there's enough image to be displayed, I let it up to you to figure out the details, but it's not a magic formula don't worry :)
    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * tableView.frame.height) - cellHeight) / 2
        return imageVisibleHeight + maxOffset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad ok\n")

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        bookImages = [String?]()
        bookTitle = [String?]()
        objectID = [String?]()
        
        let query = PFQuery(className: "Book")
        
        query.whereKey("userID", equalTo: (PFUser.currentUser()?.objectId)!)
        
        query.findObjectsInBackgroundWithBlock { (books, error) in
            guard (books != nil) else {
                print(error)
                return
            }
            
            for book in books! {
                print("Book :\n\(book)\n\n")
                if let coverString = book["cover"] {
                    self.bookImages.append(coverString as? String)
                } else {
                    self.bookImages.append(nil)
                }
                
                if let titleString = book["title"] {
                    self.bookTitle.append(titleString as? String)
                } else {
                    self.bookTitle.append("No Title")
                }
                
                // fix that
//                if let idString = book["objectID"] {
//                    self.objectID.append(idString as? String)
//                }
            }
            
//            print(self.objectID)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView?.reloadData()
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookTitle.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("parallaxCell", forIndexPath: indexPath) as! ParallaxTableViewCell
        let imgString = bookImages[indexPath.row]
        if imgString != nil {
            if let url = NSURL(string: imgString!) {
                cell.imageBook.pin_setImageFromURL(url)
            }
        }else{
            cell.imageView?.image = UIImage(named: "iu")!
        }
        cell.cellHeight.constant = parallaxImageHeight
        cell.cellTop.constant = parallaxOffsetFor(tableView.contentOffset.y, cell: cell)
        cell.titleLabel.text = bookTitle[indexPath.row]
        return cell
    }
    
    // Used when the table dequeues a cell, or when it scrolls
    func parallaxOffsetFor(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return ((newOffsetY - cell.frame.origin.y) / parallaxImageHeight) * parallaxOffsetSpeed
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        for cell in tableView.visibleCells as! [ParallaxTableViewCell] {
            cell.cellTop.constant = parallaxOffsetFor(offsetY, cell: cell)
        }
    }

//    @IBAction func logout(sender: AnyObject) {
//        //        PFUser.logOut()
//        //        self.performSegueWithIdentifier("logout", sender: self)
//    }
    
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
