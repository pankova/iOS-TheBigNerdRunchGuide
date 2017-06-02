//
//  ImageStore.swift
//  Homepwner
//
//  Created by Pankova Mariya on 26.05.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit
class ImageStore: NSObject {
    let cache = NSCache<AnyObject, AnyObject>()
    
    func setImage(image: UIImage, forkey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        
        // 15: bronze (save in PNG instead of JPEG)
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: imageURL as URL, options: .atomic)
            } catch {
                print("Error writing image on disk \(error)")
            }
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key) as NSURL
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        do {
            try FileManager.default.removeItem(at: imageURL as URL)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
}
