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

struct imageLinks: Decodable {
    
    let coverString: String!
    
    init?(json: JSON) {
        if let _medium: String = "medium" <~~ json {
            coverString = _medium
        } else if let _small: String! = "small" <~~ json {
            coverString = _small
        } else if let _thumbnail: String! = "thumbnail" <~~ json {
            coverString = _thumbnail
        } else if let _smallThumbnail: String! = "smallThumbnail" <~~ json {
            coverString = _smallThumbnail
        } else {
            coverString = nil
        }
    }
    
}

struct Book: Decodable {
    let selfLink:String!
    let coverURL:imageLinks!
    let title:String!
    let authors:[String]!
//    let ISBN13:String!
    let ID:String!
    let desc:String!
    let publisher:String!
    let publishedDate:String!
    let pageCount:Int!
    let language:String!
    let categories:[String]!
    let averageRating:Double! //min 1 to max 5
    let previewLink:String!


    init?(json: JSON) {
        guard let data: JSON = "items" <~~ json else {
            print("Error no JSON data available")
            return nil
        }
        
        guard let _selfLink: String = "selfLink" <~~ data else {
            return nil
        }
        selfLink = _selfLink
        
        guard let _coverURL: imageLinks = "imageLinks" <~~ data else {
            return nil
        }
        coverURL = _coverURL
        
        guard let _title: String = "volumeInfo.title" <~~ data else {
            return nil
        }
        title = _title
        
        guard let _authors: [String] = "volumeInfo.authors" <~~ data else {
            return nil
        }
        authors = _authors
        
//        guard let _ISNB13: String = "volumeInfo.industryIdentifiers" <~~ data else {
//            return nil
//        }
//        ISBN13 = _ISNB13
        
        guard let _id: String = "id" <~~ data else {
            return nil
        }
        ID = _id
        
        guard let _desc: String = "volumeInfo.description" <~~ data else {
            return nil
        }
        desc = _desc
        
        guard let _publisher: String = "volumeInfo.publisher" <~~ data else {
            return nil
        }
        publisher = _publisher
        
        guard let _publishedDate: String = "volumeInfo.publishedDate" <~~ data else {
            return nil
        }
        publishedDate = _publishedDate
        
        guard let _pageCount: Int = "volumeInfo.pageCount" <~~ data else {
            return nil
        }
        pageCount = _pageCount
        
        guard let _language: String = "volumeInfo.language" <~~ data else {
            return nil
        }
        language = _language
        
        guard let _categories: [String] = "volumeInfo.categories" <~~ data else {
            return nil
        }
        categories = _categories
        
        guard let _averageRating: Double = "volumeInfo.averageRating" <~~ data else {
            return nil
        }
        averageRating = _averageRating
        
        guard let _previewLink: String = "volumeInfo.previewLink" <~~ data else {
            return nil
        }
        previewLink = _previewLink
        
    }
    
}