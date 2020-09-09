//
//  UIView+Extension.swift
//  Almanakka
//
//  Created by Kosuke Nishimura on 2019/12/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

extension UIView {

    func addFillingSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor)
            ]
        )

    }
    
    @discardableResult
    func placeAtCenter(of view: UIView) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
        
        return self
    }
    
    @discardableResult
    func setSizeConstraints(width: CGFloat, height: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: width),
                heightAnchor.constraint(equalToConstant: height)
            ]
        )
        
        return self
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    static func circularView(frame: CGRect, corners: UIRectCorner, radius: CGFloat, backgroundColor: UIColor?) -> UIView {
        let view = UIView(frame: frame)
        view.roundCorners(corners: corners, radius: radius)
        view.backgroundColor = backgroundColor
        return view
    }
}
