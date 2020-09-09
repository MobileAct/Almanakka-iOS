//
//  PageCalculator.swift
//  ALKInterface
//
//  Created by Kosuke Nishimura on 2020/05/27.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

struct PageCalculator {
    
    private let collectionView: UICollectionView
    private let direction: UICollectionView.ScrollDirection
    
    init(collectionView: UICollectionView, direction: UICollectionView.ScrollDirection) {
        self.collectionView = collectionView
        self.direction = direction
    }
    
    func page() -> Int {
        
        let page: Int
        
        switch direction {
        case .horizontal:
            page = pageForHorizontalPosition()
        case .vertical:
            page = pageForVerticalPosition()
        @unknown default:
            page = -1
        }
        
        return page > 0 ? page : 0
    }
    
    private func pageForHorizontalPosition() -> Int {
        let offsetX = ceil(Double(collectionView.contentOffset.x))
        let width = Double(collectionView.bounds.size.width)
        return page(offsetOfPage: offsetX, lengthOfPage: width)
    }
    
    private func pageForVerticalPosition() -> Int {
        let offsetY = ceil(Double(collectionView.contentOffset.y))
        let height = Double(collectionView.bounds.size.height)
        return page(offsetOfPage: offsetY, lengthOfPage: height)
    }
    
    private func page(offsetOfPage offset: Double, lengthOfPage length: Double) -> Int {
        Int(floor(offset / length))
    }
}
