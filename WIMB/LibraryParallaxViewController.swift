//
//  LibraryParallaxViewController.swift
//  WIMB
//
//  Created by Gil Felot on 24/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//


import UIKit
import Parse

class LibraryParallaxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    
    
    var myLib: [BookFromCloud] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView?.separatorColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        myLib = []
        
        let query = PFQuery(className: "Book")
        query.whereKey("userID", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (books, error) in
            guard (books != nil) else {
                print(error)
                return
            }
            
            for book in books! {
                let myBook = BookFromCloud(book: book)
                self.myLib.append(myBook)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView?.reloadData()
            }
        }
    }
    
    //MARK: - UITableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLib.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ParallaxCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ParallaxCell
        let bookData = myLib[indexPath.row]
        let imgPFFile = bookData.data["coverFile"] as? PFFile
        if imgPFFile != nil {
            imgPFFile?.getDataInBackgroundWithBlock({ (imageData, error) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.parallaxImage?.image = image
                    }
                } else {
                    print(error)
                }
            })
        }else{
            cell.imageView?.image = UIImage(named: "No_image")!
        }
//        cell.titleLabel.text = bookData.data["title"] as? String
        return cell
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let visibleCells = tableView!.visibleCells as? [ParallaxCell] {
            for cell in visibleCells {
                cell.tableView(tableView!, didScrollOnView: view)
            }
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let bookData = myLib[indexPath.row]
            let objectId = bookData.data["objectId"] as! String
            let query = PFQuery(className: "Book")
            query.whereKey("objectId", equalTo: objectId)
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error) in
                for object in objects! {
                    object.deleteEventually()
                }
            })
            myLib.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showBook", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBook" {
            let vc = segue.destinationViewController as! BookViewParallaxController
            let row = sender!.row
            vc.myBookFromCloud = myLib[row]
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        presentViewController(viewController, animated: true, completion: nil)
    }
}

