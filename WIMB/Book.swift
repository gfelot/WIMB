//
//  Book.swift
//  WIMB
//
//  Created by Gil Felot on 10/01/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import Foundation
import UIKit

class Book {
    private var cover:UIImage!
    private var title:String!
    private var author:String!
    private var ISBN:String!
    private var ID:String!
    
    init (cover:UIImage, title:String, author:String, ISBN:String, ID:String) {
        self.cover = cover
        self.title = title
        self.author = author
        self.ISBN = ISBN
        self.ID = ID
    }
    
    func setCover(image:UIImage) {
        cover = image
    }
    
    func getCover() -> UIImage {
        return cover
    }
    
    func setTitle(_title:String) {
        title = _title
    }
    
    func getTitle() -> String {
        return title
    }
    
    func setAuthor(_author:String) {
        author = _author
    }
    
    func getAuthor() -> String {
        return author
    }
    
    func setISBN(_ISBN:String) {
        ISBN = _ISBN
    }
    
    func getISBN() -> String {
        return ISBN
    }
    
    func setID(_ID:String) {
        ID = _ID
    }
    
    func getID() -> String {
        return ID
    }
    
}