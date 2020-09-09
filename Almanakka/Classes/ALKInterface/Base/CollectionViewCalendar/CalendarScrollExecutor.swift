//
//  CalendarScrollExecutor.swift
//  ALKInterface
//
//  Created by Kosuke Nishimura on 2020/05/27.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

struct CalendarScrollExecutor {
    
    private let collectionView: UICollectionView
    private let dataManager: InfiniteCalendarDataManager
    
    init(
        collectionView: UICollectionView,
        dataManager: InfiniteCalendarDataManager
    ) {
        self.collectionView = collectionView
        self.dataManager = dataManager
    }
    
    func scrollToPreviousYear(scrollDirection direction: UICollectionView.ScrollDirection, newOffset: CGFloat) {
        dataManager.incrementYear()
        collectionView.reloadData()
        setContentOffset(direction, newOffset)
    }
    
    func scrollToNextYear(scrollDirection direction: UICollectionView.ScrollDirection, newOffset: CGFloat) {
        dataManager.decrementYear()
        collectionView.reloadData()
        setContentOffset(direction, newOffset)
    }
    
    private func setContentOffset(_ direction: UICollectionView.ScrollDirection, _ newOffset: CGFloat) {
        switch direction {
        case .horizontal:
            collectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
        case .vertical:
            collectionView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
        @unknown default:
            fatalError("Unknown Direction")
        }
    }
}
