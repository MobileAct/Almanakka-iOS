//
//  ALKCollectionViewHeader.swift
//  ALKInterface
//
//  Created by Maharjan Binish on 2020/05/20.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class ALKCollectionViewHeader: UICollectionReusableView {

    @IBOutlet private weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(with month: Int, year: Int) {
        let displayText = "\(year)-\(month)"
        headerLabel.text = displayText
    }
    
}
