//
//  Photo.swift
//  Photorama
//
//  Created by Pankova Mariya on 25.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoID == rhs.photoID
}
