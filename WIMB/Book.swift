//
//  BookFromJSON.swift
//  WIMB
//
//  Created by Gil Felot on 10/01/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import Foundation
import UIKit
import Gloss
import Parse


struct BookItems: Decodable {
    let data: [BookFromJSON]?
    
    init?(json: JSON) {
        self.data = "items" <~~ json
    }
}

struct BookFromJSON: Decodable {
    
    var data = JSON()

    init?(json: JSON) {
        
        let tools = Tools()
        
        if let _id: String = "id" <~~ json {
            data["id"] = _id
        }
        if let selfLink: String = "selfLink" <~~ json {
            data["selfLink"] = tools.httpsConverter(selfLink)
        }
        if let imageLinks: ImageLinks = "volumeInfo.imageLinks" <~~ json {
            if let cover: String? = imageLinks.coverString {
                data["cover"] = tools.httpsConverter(cover)
            }
        }
        if let titre: String = "volumeInfo.title" <~~ json {
            data["title"] = titre
        }
        if let authors: [String] = "volumeInfo.authors" <~~ json {
            data["authors"] = authors
        }
        if let desc: String = "volumeInfo.description" <~~ json {
            data["desc"] = desc
        }
        if let publisher : String = "volumeInfo.publisher" <~~ json {
            data["publisher"] = publisher
        }
        if let publishedDate: String = "volumeInfo.publishedDate" <~~ json {
            data["publishedDate"] = publishedDate
        }
        if let pageCount: String = "volumeInfo.pageCount" <~~ json {
            data["pageCount"] = pageCount
        }
        if let language: String = "volumeInfo.language" <~~ json {
            data["language"] = language
        }
        if let categories: [String] = "volumeInfo.categories" <~~ json {
            data["categories"] = categories
        }
        if let averageRating: Double = "volumeInfo.averageRating" <~~ json {
            data["averageRating"] = averageRating
        }
    }
    
    func prepareToCloud() -> PFObject {
        let book = PFObject(className: "BookFromJSON")
        book["userID"] = PFUser.currentUser()?.objectId
        for (key, value) in data {
            book[key] = value
        }
        return book
    }
}

struct ImageLinks: Decodable {
    
    let coverString: String?
    
    init?(json: JSON) {
        let medium: String? = "medium" <~~ json
        let small: String? = "small" <~~ json
        let thumbnail: String? = "thumbnail" <~~ json
        let smallThumbnail: String? = "smallThumbnail" <~~ json
        
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

struct BookFromCloud {
    var data = JSON()
    
    init(book: PFObject) {
        self.data["objectId"] = book.objectId
        self.data["authors"] = book["authors"]
        self.data["averageRating"] = book["averageRating"]
        self.data["categories"] = book["categories"]
        self.data["cover"] = book["cover"]
        self.data["id"] = book["id"]
        self.data["language"] = book["language"]
        self.data["publishedDate"] = book["publishedDate"]
        self.data["publisher"] = book["publisher"]
        self.data["selfLink"] = book["selfLink"]
        self.data["title"] = book["title"]
        self.data["userID"] = book["userID"]
    }
    
    
    
}

//struct ISBN: Decodable {
//    
//    enum Type: String {
//        case ISBN10 = "ISBN_10"
//        case ISBN13 = "ISBN_13"
//    }
//    
//    let type: Type
//    let identifier: String
//    
//    init?(json: JSON) {
//        guard  let type: Type = "type" <~~ json,
//            let identifier: String = "identifier" <~~ json else {
//                return nil
//        }
//        
//        self.type = type
//        self.identifier = identifier
//    }
//    
//}