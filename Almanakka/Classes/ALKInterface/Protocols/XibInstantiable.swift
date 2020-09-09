//
//  XibInstantiable.swift
//  Almanakka
//
//  Created by Kosuke Nishimura on 2019/12/19.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public protocol XibInstantiable { }

public extension XibInstantiable where Self: UIView {
    
    static func instantiateFromXib(fileName: String = className) -> Self {
        
        let bundle = Bundle(path: Bundle(for: self).path(forResource: "Almanakka", ofType: "bundle")!)

        guard let view = UINib(nibName: fileName, bundle: bundle).instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError(fileName + "failed")
        }
        return view
    }
    
}

extension UIView: XibInstantiable { }
