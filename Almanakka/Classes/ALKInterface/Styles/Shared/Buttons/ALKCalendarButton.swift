//
//  ALKCalendarButton.swift
//  ALKInterface
//
//  Created by Maharjan Binish on 2020/05/21.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class ALKCalendarButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupLayout()
        setupShadow()
    }
    
    private func setupLayout() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
    
    private func setupShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius  = 2
        layer.shadowOpacity = 0.3
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
}
