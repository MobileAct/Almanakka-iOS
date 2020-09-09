//
//  WeekdayCollectionViewCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final public class WeekdayCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let maxColumnNumber = 7
    private let weekdays = Weekday.weekdaySymbols(firstWeekday: .sunday, useShortSymbols: true)
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerXib(cellClass: DayCollectionViewCell.self)
    }
}
extension WeekdayCollectionViewCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.className, for: indexPath) as? DayCollectionViewCell else {
            fatalError()
        }
        makeWeekdaysCustomize(for: cell, size: 12, color: "#7F7F7F")
        cell.dayLabelText = weekdays[indexPath.row]
        return cell
    }
}
extension WeekdayCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(maxColumnNumber)
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
extension WeekdayCollectionViewCell: UICollectionViewDelegate {}

extension WeekdayCollectionViewCell {
    //今だけ使います。これからカスタマイズのn為にファイルを作ったら削除
    func makeWeekdaysCustomize(for cell: DayCollectionViewCell, size: CGFloat, color: String) {
        cell.dayLabelTextColor = UIColor(hexString: color)
        cell.dayLabelFont = cell.dayLabelFont.withSize(size)
    }
}

