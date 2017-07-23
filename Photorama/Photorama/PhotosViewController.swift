//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Pankova Mariya on 25.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UITabBarDelegate, PhotoInfoDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tabBar: UITabBar!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        countCellSize()
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate:  nil, sortDescriptors: [sortByDateTaken])
            OperationQueue.main.addOperation {
                self.photoDataSource.shownPhotos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index:0) as IndexSet)
            }
        }
        self.tabBar.selectedItem = tabBar.items?[0]
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.shownPhotos[indexPath.row]
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            OperationQueue.main.addOperation {
                if let photoIndex = self.photoDataSource.shownPhotos.index(of: photo) {
                    let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                    
                    if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                        cell.updateWithImage(photo: photo)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.shownPhotos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
                destinationVC.delegate = self
            }
        }
    }
    
    func countCellSize() {
        // default size if any error occurs
        var cellWidth = CGFloat(10)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfCellsPerRow: CGFloat = 3
            let spacing = flowLayout.minimumLineSpacing
            cellWidth = CGFloat((view.frame.width - (spacing * (numberOfCellsPerRow - 1)) - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / numberOfCellsPerRow)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.countCellSize()
        }
    }
        
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            self.photoDataSource.setShownAllPhotos()
        } else {
            self.photoDataSource.setShownFavoritePhotos()
        }
        self.collectionView.reloadData()
    }
    
    func favoriteStatusChangedDelegate(photoInfo: PhotoInfoViewController) {
        if let photo = photoInfo.photo {
            self.photoDataSource.changeStatusFavoritePhoto(photo: photo)
        }
        self.collectionView.reloadData()
    }
}
