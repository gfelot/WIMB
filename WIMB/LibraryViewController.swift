//
//  LibraryViewController.swift
//  WIMB
//
//  Created by Gil Felot on 16/03/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse

let parallaxCellIdentifier = "parallaxCell"

class LibraryViewController: UICollectionViewController {

    var bookImages = [String?]()
    var bookTitle = [String?]()
    var nbBooks: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className: "Book")
        
        bookTitle.append("test")
        bookImages.append(nil)
        print("Tableau image1: \(bookImages)\n")
        print("Tableau title1: \(bookTitle)\n")
        
        query.whereKey("userID", equalTo: (PFUser.currentUser()?.objectId)!)
        
        query.findObjectsInBackgroundWithBlock { (books, error) in
            guard (books != nil) else {
                print(error)
                return
            }
            for book in books! {

                if let coverString = book["cover"] {
                    print("coverString OK : \(coverString)")
                    self.bookImages.append(coverString as? String)
                } else {
                    print("coverString nil")
                    self.bookImages.append(nil)
                }
                
                if let titleString = book["title"] {
                    print("titleString OK : \(titleString)")
                    self.bookTitle.append(titleString as? String)
                } else {
                    print("titleString nil")
                    self.bookTitle.append("No Title")
                }
            }
        }
        print("Tableau image2: \(bookImages)\n")
        print("Tableau title2: \(bookTitle)\n")
        let collectionView = self.collectionView
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NB Book: \(bookTitle.count)")
        return bookTitle.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let parallaxCell = collectionView.dequeueReusableCellWithReuseIdentifier(parallaxCellIdentifier, forIndexPath: indexPath) as! ParallaxCollectionViewCell
        let imgString = bookImages[indexPath.row]
        if imgString != nil {
            if let url = NSURL(string: imgString!) {
                print("Cover Found ")
                parallaxCell.imageView.pin_setImageFromURL(url)
            }
        }else {
            print("Cover Not Found")
            parallaxCell.image = UIImage(named: "iu")!
        }
        
        return parallaxCell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells() as? [ParallaxCollectionViewCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / ImageHeight) * OffsetSpeed
            parallaxCell.offset(CGPointMake(0.0, yOffset))
        }
    }
    

    @IBAction func logout(sender: AnyObject) {
//        PFUser.logOut()
//        self.performSegueWithIdentifier("logout", sender: self)
    }
    
}
