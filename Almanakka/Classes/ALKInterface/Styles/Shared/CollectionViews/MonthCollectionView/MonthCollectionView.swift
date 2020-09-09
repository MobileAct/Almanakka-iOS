//
//  MonthCollectionView.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public final class MonthCollectionView: UICollectionView {
    
    private var viewmodel: MonthCollectionViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        registerXib(cellClass: MonthCollectionViewCell.self)
        dataSource = self
    }
    
    public func reload(_ viewmodel: MonthCollectionViewModel) {
        self.viewmodel = viewmodel
        reloadData()
    }
    
    public func bind(_ viewmodel: MonthCollectionViewModel) {
        self.viewmodel = viewmodel
    }
}

extension MonthCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.numberOfItemsInSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: MonthCollectionViewCell.className, for: indexPath) as? MonthCollectionViewCell else {
            fatalError()
        }
        cell.bind(viewmodel.cellViewModel(forRowAt: indexPath))
        
        return cell
    }
}

