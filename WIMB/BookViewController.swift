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
    
    var book:Book!
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if book == nil {
            performSegueWithIdentifier("scanCode", sender: nil)
        } else {
            bookImage.image = book.getCover()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if book != nil {
            print(book.getAuthor())
            print(book.getISBN())
            print(book.getTitle())
            
        }
    }

    
    //Set book view controller as delegate to scan book view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is ScanBookViewController{
            let scanBookViewController:ScanBookViewController = segue.destinationViewController as! ScanBookViewController
            scanBookViewController.delegate = self
        }
    }
    
    func didScanBook(scannedBook:Book)
    {
        self.book = scannedBook
    }

}
