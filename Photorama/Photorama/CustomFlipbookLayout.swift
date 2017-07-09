//
//  CustomFlipbookLayout.swift
//  Photorama
//
//  Created by Pankova Mariya on 06.07.17.
//  Copyright © 2017 Pankova Mariya. All rights reserved.
//

import UIKit

class CustomFlipbookLayout: UICollectionViewLayout {
    var numberOfPhotos = 0
    
    private var contentHeight: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.height - insets.top
    }
    
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGFloat(numberOfPhotos) * collectionView!.bounds.width - (insets.left + insets.right) - 10
    }
    
    override func prepare() {
        super.prepare()
        
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        numberOfPhotos = (collectionView?.numberOfItems(inSection: 0))!
        print("Number: \(numberOfPhotos)")
        collectionView?.isPagingEnabled = true
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        if numberOfPhotos == 0 {
            return layoutAttributes
        }
        for i in 0...max(0, numberOfPhotos-1) {
            let indexPath = IndexPath(item: i, section: 0)
            
            if let attr = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attr)
            } else {
                print("!!! fail to create attrs !!!")
            }
        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) ->UICollectionViewLayoutAttributes? {
        print(#function)
    
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let frame = getFrame(collectionView: collectionView!)
        layoutAttributes.frame = frame
        
        let ratio = getRatio(collectionView: collectionView!, indexPath: indexPath)
        let rotation = getRotation(indexPath: indexPath, ratio: min(max(ratio, -1), 1))
        layoutAttributes.transform3D = rotation
        
        if indexPath.row == 0 {
            layoutAttributes.zIndex = Int.max
        }
        
        return layoutAttributes
        
    }
    
    func getFrame(collectionView: UICollectionView) -> CGRect {
        print(#function)

        var frame = CGRect()
        
        frame.origin.x = CGFloat(0 - collectionView.bounds.width / 2) + collectionView.contentOffset.x
        frame.origin.y = CGFloat(0)
        frame.size.width = collectionView.bounds.width
        frame.size.height = collectionViewContentSize.height
        
        return frame
    }
    
    func getRatio(collectionView: UICollectionView, indexPath: IndexPath) -> CGFloat {
        print(#function)

        let page = CGFloat(indexPath.item)
        let ratio = CGFloat(page - (collectionView.contentOffset.x / collectionView.bounds.width))
        
        return ratio
    }
    
    func getAngle(indexPath: IndexPath, ratio: CGFloat) -> CGFloat {
        print(#function)

        var angle: CGFloat = 0
        angle = ratio * CGFloat(Double.pi / 2)
        
        return angle
    }
    
    func makePerspectiveTransform() -> CATransform3D {
        print(#function)

        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -3000
        
        return transform
    }
    
    func getRotation(indexPath: IndexPath, ratio: CGFloat) -> CATransform3D {
        print(#function)

        var transform = makePerspectiveTransform()
        let angle = getAngle(indexPath: indexPath, ratio: ratio)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        return transform
    }
}
