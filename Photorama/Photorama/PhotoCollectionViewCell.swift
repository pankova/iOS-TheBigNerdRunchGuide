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
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(image: nil)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print(#function)
        super.apply(layoutAttributes)
        
        layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    }
}
