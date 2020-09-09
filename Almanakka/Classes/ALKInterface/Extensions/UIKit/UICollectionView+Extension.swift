//
//  UICollectionView+Extension.swift
//  Almanakka
//
//  Created by Kosuke Nishimura on 2019/12/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

internal extension UICollectionView {
    
    func registerXib(cellClass: UICollectionViewCell.Type) {
        let fileName = cellClass.className
        let reuseId = cellClass.className
        
        let bundle = BundleLoader.AlmanakkaBundle()
        register(UINib(nibName: fileName, bundle: bundle), forCellWithReuseIdentifier: reuseId)
    }
}
