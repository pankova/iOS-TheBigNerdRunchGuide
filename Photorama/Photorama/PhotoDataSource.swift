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
    //var favoritesPhotos = [Photo]()
    
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
        if self.allPhotos.count > 0 {
            self.listIndex = 1
            self.chooseFavoritePhotos()

        }
    }
    
    func chooseFavoritePhotos() {
        var favoritesPhotos = [Photo]()
        for photo in self.allPhotos {
            if photo.isFavorite {
                favoritesPhotos.append(photo)
            }
        }
        self.shownPhotos = favoritesPhotos
    }
    
    func setShownAllPhotos() {
        self.listIndex = 0
        self.shownPhotos = self.allPhotos
    }
    
    var listIndex = 0
    
    func updateDataSource() {
        if self.listIndex == 1{
            self.chooseFavoritePhotos()
        }
        //if photo.isFavorite {//let indexPath = self.favoritesPhotos.index(of: photo) {
            //self.favoritesPhotos.remove(at: indexPath)
            //photo.isFavorite = false
            //self.shownPhotos = self.favoritesPhotos
        //} else {
          //  photo.isFavorite = true
            //self.favoritesPhotos.append(photo)
        //}
        print(123)
    }
}
