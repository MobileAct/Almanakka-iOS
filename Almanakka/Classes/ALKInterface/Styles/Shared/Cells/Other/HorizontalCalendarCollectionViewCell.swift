//
//  HorizontalCalendarCollectionViewCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final public class HorizontalCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let years = [Year(referenceDate: .today)]
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerXib(cellClass: DayInMonthCollectionViewCell.self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let currentMonth: Int = Date.today.month
        let currentIndexPath = IndexPath(row: currentMonth - 1, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
    }
}
extension HorizontalCalendarCollectionViewCell: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return years[section].months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayInMonthCollectionViewCell.className, for: indexPath) as? DayInMonthCollectionViewCell else {
            fatalError()
        }
        cell.popularize(month: years[0].months[indexPath.row])
        return cell
    }
}
extension HorizontalCalendarCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
extension HorizontalCalendarCollectionViewCell: UICollectionViewDelegate {
    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            print("Selected: \(indexPath)")
//        }
}



