//
//  Article+CoreDataProperties.swift
//  
//
//  Created by Aubane COULOMBIER on 12/20/19.
//
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var titre: String?
    @NSManaged public var content: String?
    @NSManaged public var langue: String?
    @NSManaged public var image: NSData?
    @NSManaged public var date_de_creation: NSDate?
    @NSManaged public var date_de_modification: NSDate?

    override public var description:String {
        let desc = "titre : \(String(describing: titre))\r\ncontent : \(String(describing: content))\r\nlangue : \(String(describing: langue))\r\nimage : \(String(describing: image))\r\ndate de creation : \(String(describing: date_de_creation))\r\ndate de modification : \(String(describing: date_de_modification))"
        return desc
    }
}
