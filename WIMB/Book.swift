//
//  Book.swift
//  WIMB
//
//  Created by Gil Felot on 10/01/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import Foundation
import UIKit
import Gloss

struct BookItems: Decodable {
    let data: [Book]?
    
    init?(json: JSON) {
        self.data = "items" <~~ json
    }
}

struct Book: Decodable {
    let selfLink:NSURL!
    let coverURL:imageLinks!
    let title:String!
    let authors:[String]!
    let isbn:[ISBN]!
    let id:String!
    let desc:String!
    let publisher:String!
    let publishedDate:String!
    let pageCount:Int!
    let language:String!
    let categories:[String]!
    let averageRating:Double! //min 1 to max 5
    let previewLink:NSURL!


    init?(json: JSON) {

        self.id = "id" <~~ json
        self.selfLink = "selfLink" <~~ json
        self.coverURL = "volumeInfo.imageLinks" <~~ json
        self.title = "volumeInfo.title" <~~ json
        self.authors = "volumeInfo.authors" <~~ json
        self.isbn = "volumeInfo.industryIdentifiers" <~~ json
        self.desc = "volumeInfo.description" <~~ json
        self.publisher = "volumeInfo.publisher" <~~ json
        self.publishedDate = "volumeInfo.publishedDate" <~~ json
        self.pageCount = "volumeInfo.pageCount" <~~ json
        self.language = "volumeInfo.language" <~~ json
        self.categories = "volumeInfo.categories" <~~ json
        self.averageRating = "volumeInfo.averageRating" <~~ json
        self.previewLink = "volumeInfo.previewLink" <~~ json
        
    }
    
}

struct imageLinks: Decodable {
    
    let coverString: NSURL!
    
    init?(json: JSON) {
        let medium: NSURL! = "medium" <~~ json
        let small: NSURL! = "small" <~~ json
        let thumbnail: NSURL! = "thumbnail" <~~ json
        let smallThumbnail: NSURL! = "smallThumbnail" <~~ json
        
        if (medium != nil) {
            self.coverString = medium
        } else if (small != nil) {
            self.coverString = small
        } else if (thumbnail != nil) {
            self.coverString = thumbnail
        } else if (smallThumbnail != nil) {
            self.coverString = smallThumbnail
        } else {
            self.coverString = nil
        }
    }
    
}

struct ISBN:Decodable {
    let type: String!
    let identifier:String!
    
    init?(json: JSON) {
        self.type = "type" <~~ json
        self.identifier = "identifier" <~~ json
    }
}