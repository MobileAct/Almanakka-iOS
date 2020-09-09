//
//  MonthsView.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class MonthsView: UIView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let monthComponents = Calendar.current.monthSymbols
    private let currentMonth = Date.today.month

    var tapAction: ((Int) -> Void)!
    var textColor: UIColor = UIColor.black

    public override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerXib(cellClass: MonthCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let index = IndexPath(row: currentMonth - 1, section: 0)
        selectMonth(at: index, animated: false)
    }

    public func selectMonth(at index: IndexPath, animated: Bool) {
        
        print("MonthsView: Month at index \(index) selected. (animated: \(animated ? "yes" : "no"))")
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.selectItem(at: index, animated: animated, scrollPosition: .centeredHorizontally)

        }
    }
}

// MARK: - Datasource
extension MonthsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthComponents.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.className, for: indexPath) as? MonthCell else {
            fatalError()
        }

        cell.setMonthsLabel(with: monthComponents[indexPath.row])
        cell.textColor = textColor
        cell.indicatorColor = textColor
        return cell
    }
}

// MARK: - Delegate
extension MonthsView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapAction(indexPath.row)
    }
}

// MARK: - DelegateFlowLayout
extension MonthsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = collectionView.frame.width / 3
        return .init(width: width, height: height)
    }
}

