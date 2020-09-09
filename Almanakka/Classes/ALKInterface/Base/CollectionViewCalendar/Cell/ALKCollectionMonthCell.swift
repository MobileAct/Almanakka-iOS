//
//  ALKCollectionMonthCell.swift
//  ALKInterface
//
//  Created by Maharjan Binish on 2020/05/15.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class ALKCollectionMonthCell: UICollectionViewCell {
    
    var month = Month(referenceDate: .today) {
        didSet {
            monthView.month = month
        }
    }
    
    var style: ALKCalendarAppearance = ALKCalendarAppearance.Default {
        didSet {
            monthView.style = style
        }
    }
    
    var delegate: ALKMonthViewDelegate? {
        get {
            return monthView.delegate
        }
        
        set {
            monthView.delegate = newValue
        }
    }
    
    var selectionManager: ALKSelectionManager? {
        didSet {
            monthView.selectionManager = selectionManager
        }
    }
    
    private var monthView: ALKMonthView = ALKMonthView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        monthView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        addSubview(monthView)
    }
    
}
