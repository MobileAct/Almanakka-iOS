//
//  NibDesignable.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol NibDesignable where Self: UIView {

}

public extension NibDesignable {

    // Used to load @IBDesignable views
    func loadOwnedViewFromNib() {
        
        // Load the Xib
        let view = Self.instantiateFromXib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
