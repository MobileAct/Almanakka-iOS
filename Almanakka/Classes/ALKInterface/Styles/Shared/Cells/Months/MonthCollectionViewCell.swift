//
//  MonthCollectionViewCell.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public final class MonthCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var dayCollectionView: UICollectionView!
    
    private let maxColumnNumber = 7
    private let maxRowNumber = 6
    
    private var viewmodel: MonthCollectionViewCellViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        dayCollectionView.registerXib(cellClass: DayCollectionViewCell.self)
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
    }
    
    public func bind(_ viewmodel: MonthCollectionViewCellViewModel) {
        self.viewmodel = viewmodel
        
        // isTodayの時の丸が使い回されることを防ぐ
        dayCollectionView.reloadData()
    }
}

extension MonthCollectionViewCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.numberOfItem()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dayCollectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.className, for: indexPath) as? DayCollectionViewCell else {
            fatalError()
        }
        cell.bind(viewmodel.cellViewModel(forItemAt: indexPath))
        
        return cell
    }
}

extension MonthCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width / CGFloat(maxColumnNumber)
        let height = frame.height / CGFloat(maxRowNumber)
        return .init(width: width, height: height)
    }
}

