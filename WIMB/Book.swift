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
    let selfLinkString:String!
    let selfLink:NSURL!
    let imagesLinks:imageLinks!
    let coverURL:NSURL!
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
    let previewLinkString:String!
    let previewLink:NSURL!


    init?(json: JSON) {

        self.id = "id" <~~ json
        self.selfLinkString = "selfLink" <~~ json
        self.imagesLinks = "volumeInfo.imageLinks" <~~ json
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
        self.previewLinkString = "volumeInfo.previewLink" <~~ json
        
        
        func httpsConverter(str:String!) -> NSURL {
            var tmp = str
            if str != nil {
                if tmp.hasPrefix("http://") {
                    tmp.removeRange(Range<String.Index>(str.startIndex ..< str.startIndex.advancedBy(7)))
                    tmp.insertContentsOf("https://".characters, at: str.startIndex)
                }
            }
            return NSURL(string: tmp)!
        }
        
        self.selfLink = httpsConverter(self.selfLinkString)
        self.previewLink = httpsConverter(self.previewLinkString)
        self.coverURL = httpsConverter(self.imagesLinks.coverString)
    }
    
}

struct imageLinks: Decodable {
    
    let coverString: String!
    
    init?(json: JSON) {
        let medium: String! = "medium" <~~ json
        let small: String! = "small" <~~ json
        let thumbnail: String! = "thumbnail" <~~ json
        let smallThumbnail: String! = "smallThumbnail" <~~ json
        
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