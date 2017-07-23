//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Pankova Mariya on 30.06.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var star: UIImageView!
    
    func updateWithImage(photo: Photo?) {
        star.isHidden = true
        if let imageToDisplay = photo?.image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            if (photo?.isFavorite)! {
                star.isHidden = false
            }
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(photo: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(photo: nil)
    }
}
