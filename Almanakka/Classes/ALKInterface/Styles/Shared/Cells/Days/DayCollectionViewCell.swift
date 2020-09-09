//
//  DayCollectionViewCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public final class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var selectionView: UIView!
    
    // TODO: Remove the below three properties
    public var dayLabelText: String? {
        get { dayLabel.text }
        set { dayLabel.text = newValue }
    }
    
    public var dayLabelTextColor: UIColor {
        get { dayLabel.textColor }
        set { dayLabel.textColor = newValue }
    }
    
    public var dayLabelFont: UIFont {
        get { dayLabel.font }
        set { dayLabel.font = newValue }
    }
    
    public func bind(_ viewmodel: DayCollectionViewCellViewModel) {
        dayLabel.text = "\(viewmodel.day)"
        dayLabel.textColor = viewmodel.dayColor()
        dayLabel.font.withSize(viewmodel.fontSize)
        showCircleIfIsToday(viewmodel)
    }
    
    private func showCircleIfIsToday(_ viewmodel: DayCollectionViewCellViewModel) {
        let width = viewmodel.selectionViewWidth
        selectionView
            .placeAtCenter(of: dayLabel)
            .setSizeConstraints(width: width, height: width)
        selectionView.layer.borderWidth = viewmodel.isToday ? 1 : 0
        selectionView.layer.cornerRadius = selectionView.frame.height / 2
        selectionView.layer.borderColor = viewmodel.isToday ? viewmodel.circleColor.cgColor : UIColor.clear.cgColor
    }
    
}

