//
//  AlmanakkaFlowLayout.swift
//  Almanakka
//
//  Created by Rogozhkin Vladimir on 2020/04/20.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

class ALKCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var headerHeight: CGFloat = 0
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return super.layoutAttributesForElements(in: rect)?.map { attrs in
            let attributesCopy = attrs.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributesCopy)
            return attributesCopy
        }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let attrs = super.layoutAttributesForItem(at: indexPath) {
            let attributesCopy = attrs.copy() as! UICollectionViewLayoutAttributes
            self.applyLayoutAttributes(attributesCopy)
            return attributesCopy
        }
        return nil
    }
    
    private func applyLayoutAttributes(_ attributes : UICollectionViewLayoutAttributes) {
        
        guard attributes.representedElementKind == nil else { return }
        guard let collectionView = self.collectionView else { return }
        
        var xCellOffset = CGFloat(attributes.indexPath.item % 7) * self.itemSize.width
        var yCellOffset = CGFloat(attributes.indexPath.item / 7) * self.itemSize.height + headerHeight
        
        let offset = CGFloat(attributes.indexPath.section)
        
        switch self.scrollDirection {
            case .horizontal:
                xCellOffset += offset * collectionView.frame.size.width
            case .vertical:
                yCellOffset += offset * collectionView.frame.size.height
            @unknown default:
                fatalError()
        }
        
        attributes.frame = CGRect(x:xCellOffset,
                                  y: yCellOffset,
                                  width: self.itemSize.width,
                                  height: self.itemSize.height)
    }
    
    
    func setHeaderHeight(height: CGFloat) {
        self.headerHeight = height
    }
}
