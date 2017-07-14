//
//  Photo+CoreDataClass.swift
//  Photorama
//
//  Created by Pankova Mariya on 11.07.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    var image: UIImage?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().uuidString
        dateTaken = NSDate()
    }
}
