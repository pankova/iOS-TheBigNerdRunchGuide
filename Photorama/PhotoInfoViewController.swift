//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Pankova Mariya on 02.07.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    var delegate: PhotoInfoDelegate?

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var starActive: UIImageView!
    @IBOutlet var starNoActive: UIImageView!
    
    @IBAction func changeFavoritesStatus(sender: AnyObject) {
        if self.photo.isFavorite {
            self.photo.isFavorite = false
            self.setStarNoActive()
        } else {
            self.photo.isFavorite = true
            self.setStarActive()
        }
        self.delegate?.favoriteStatusChangedDelegate(photoInfo: self)
    }
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            switch result {
            case let .Success(image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                    self.photo.viewCount += 1
                    self.viewCount.text = String(self.photo.viewCount)
                    
                    if self.photo.isFavorite {
                        self.setStarActive()
                    } else {
                        self.setStarNoActive()
                    }
                }
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTags" {
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        }
    }
    
    private func setStarActive() {
        self.starActive.isHidden = false
        self.starNoActive.isHidden = true
    }
    
    private func setStarNoActive() {
        self.starActive.isHidden = true
        self.starNoActive.isHidden = false
    }
    
}
