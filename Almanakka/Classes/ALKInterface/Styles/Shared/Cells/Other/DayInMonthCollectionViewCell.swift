//
//  DayInMonthCollectionViewCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public final class DayInMonthCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let maxColumnNumber = 7
    private let maxRowNumber = 6
    
    private let curDay: Int = Date.today.day
    private let curMont: Int = Date.today.month
    private let curYear: Int = Date.today.year
    
    private var month: Month! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerXib(cellClass: DayCollectionViewCell.self)
    }
    
    func popularize(month: Month) {
        self.month = month
    }
}
extension DayInMonthCollectionViewCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxColumnNumber * maxRowNumber
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.className, for: indexPath) as? DayCollectionViewCell else {
            fatalError()
        }
        let date = month.days[indexPath.row]
        let isToday = curDay == date.value && curMont == date.month.value && curYear == date.year.value
        
        cell.dayLabelText = "\(date.value)"

        cell.layer.borderWidth = isToday ? 1 : 0
        cell.layer.borderColor = #colorLiteral(red: 0.9058029056, green: 0.9059332013, blue: 0.9057744145, alpha: 1)
        cell.layer.cornerRadius = cell.frame.height / 2
       
        changeColor(for: cell, with: indexPath, weekendColor: "#F70067", dayColor: "#2C3135", forFirstDayInWeek: .sunday)
        
        makeDayInMonthCustomize(for: cell, size: 16)
        
        if !month.contains(day: date) {
            cell.dayLabelTextColor = .clear
        }
        
        return cell
    }
    
    //今だけ使います。これからカスタマイズのn為にファイルを作ったら削除
    func changeColor(for cell: DayCollectionViewCell, with indexPath: IndexPath, weekendColor: String, dayColor: String, forFirstDayInWeek: Weekday) {
        
        switch forFirstDayInWeek {
        case .sunday:
            switch indexPath.row {
            case 0, 6, 7, 13, 14, 20, 21, 27, 28, 34, 35, 41:
                cell.dayLabelTextColor = UIColor(hexString: weekendColor)
            default:
                cell.dayLabelTextColor = UIColor(hexString: dayColor)
            }
        case .monday:
            switch indexPath.row {
            case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34, 40, 41:
                cell.dayLabelTextColor = UIColor(hexString: weekendColor)
            default:
                cell.dayLabelTextColor = UIColor(hexString: dayColor)
            }
        default:
            cell.dayLabelTextColor = UIColor(hexString: dayColor)
        }
    }
}
extension DayInMonthCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(maxColumnNumber)
        let height = collectionView.frame.height / CGFloat(maxRowNumber)
        return CGSize(width: width, height: height)
    }
}
extension DayInMonthCollectionViewCell: UICollectionViewDelegate {
    
    // TODO: send the event to the ALKManager
    // TODO: Change the cell to represent it has been selected
    
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                print("Selected: \(indexPath)")
            }
}


extension DayInMonthCollectionViewCell {
    //今だけ使います。これからカスタマイズのn為にファイルを作ったら削除
    func makeDayInMonthCustomize(for cell: DayCollectionViewCell, size: CGFloat) {
        cell.dayLabelFont = cell.dayLabelFont.withSize(size)
        cell.dayLabelFont = UIFont.boldSystemFont(ofSize: size)
    }
}

