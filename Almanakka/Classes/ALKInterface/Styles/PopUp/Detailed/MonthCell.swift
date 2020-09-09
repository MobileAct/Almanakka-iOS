//
//  MonthCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class MonthCell: UICollectionViewCell {
    
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var selectedView: UIView!
    
    var textColor: UIColor = .black {
        didSet {
            monthLabel.textColor = textColor
        }
    }
    
    var indicatorColor: UIColor = .black {
        didSet {
            selectedView.backgroundColor = indicatorColor
        }
    }
    
    override var isSelected: Bool {
        
        get {
            return super.isSelected
        }
        
        set {
            super.isSelected = newValue
            selectedView.isHidden = !newValue
            
            print("MonthCell: \(monthLabel.text ?? "UNKNOWN") is now \(newValue ? "selected" : "deselected").")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setMonthsLabel(with text: String) {
        monthLabel.text = text
    }
}

