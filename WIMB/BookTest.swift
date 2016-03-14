////
//// Created by Gil Felot on 14/03/16.
//// Copyright (c) 2016 gfelot. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class BookTest {
//
//    var selfLink:String!
//    var coverURL:String!
//    var title:String!
//    var authors:[String]!
////    var ISBN13:String!
//    var ID:String!
//    var desc:String!
//    var publisher:String!
//    var publishedDate:String!
//    var pageCount:Int!
//    var language:String!
//    var categories:[String]!
//    var averageRating:Double! //min 1 to max 5
//    var previewLink:String!
//
//    func fillBook(data:BookFromJSON) {
//        selfLink = data.selfLink
//        coverURL = data.coverURL.coverString
//        title = data.title
//        authors = data.authors
//        ID = data.ID
//        desc = data.desc
//        publisher = data.publisher
//        publishedDate = data.publishedDate
//        pageCount = data.pageCount
//        language = data.language
//        categories = data.categories
//        averageRating = data.averageRating
//        previewLink = data.previewLink
//    }
//
//    func setCover(image:String) {
//        coverURL = image
//    }
//
//    func getCover() -> String {
//        return coverURL
//    }
//
//    func setTitle(_title:String) {
//        title = _title
//    }
//
//    func getTitle() -> String {
//        return title
//    }
//
//    func setAuthor(_authors:[String]) {
//        authors = _authors
//    }
//
//    func getAuthor() -> [String] {
//        return authors
//    }
//
////    func setISBN13(_ISBN13:String) {
////        ISBN13 = _ISBN13
////    }
////
////    func getISBN13() -> String {
////        return ISBN13
////    }
//
//    func setID(_ID:String) {
//        ID = _ID
//    }
//
//    func getID() -> String {
//        return ID
//    }
//
//    func setDesc(_desc:String) {
//        desc = _desc
//    }
//
//    func getDesc() -> String {
//        return desc
//    }
//
//    func setPublisher(_publisher:String) {
//        publisher = _publisher
//    }
//
//    func getPublisher() -> String {
//        return publisher
//    }
//
//    func setPublishedDate(_publishedDate:String) {
//        publishedDate = _publishedDate
//    }
//
//    func getPublishedDate() -> String {
//        return publishedDate
//    }
//
//    func setPageCount(_pageCount:Int) {
//        pageCount = _pageCount
//    }
//
//    func getPageCount() -> Int {
//        return pageCount
//    }
//
//    func setLanguage(_language:String) {
//        language = _language
//    }
//
//    func getLanguage() -> String {
//        return language
//    }
//
//    func setCategories(_categories:[String]) {
//        categories = _categories
//    }
//
//    func getCategories() -> [String] {
//        return categories
//    }
//
//    func setAvg(_avg:Double) {
//        averageRating = _avg
//    }
//
//    func getAvg() -> Double {
//        return averageRating
//    }
//
//    func setPreview(_preview:String) {
//        previewLink = _preview
//    }
//
//    func getPreview() -> String {
//        return previewLink
//    }
//}
