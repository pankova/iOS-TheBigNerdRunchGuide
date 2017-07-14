//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Pankova Mariya on 11.07.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }
    
    @NSManaged public var dateTaken: NSDate
    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var remoteURL: NSURL
    @NSManaged public var title: String
    
}


