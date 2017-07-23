//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Pankova Mariya on 30.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    var shownPhotos = [Photo]()
    var allPhotos = [Photo]()
    var favoritesPhotos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shownPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = shownPhotos[indexPath.row]
        cell.updateWithImage(photo: photo)
        return cell
    }
    
    func setShownFavoritePhotos() {
        self.allPhotos = self.shownPhotos
        self.shownPhotos = self.favoritesPhotos
    }
    
    func setShownAllPhotos() {
        self.shownPhotos = self.allPhotos
    }
    
    func changeStatusFavoritePhoto(photo: Photo) {
        if let indexPath = self.favoritesPhotos.index(of: photo) {
            self.favoritesPhotos.remove(at: indexPath)
            self.shownPhotos = self.favoritesPhotos
        } else {
            self.favoritesPhotos.append(photo)
        }
    }
}
