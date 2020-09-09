//
//  MonthCollectionViewModel.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol MonthCollectionViewModel {
    
    var numberOfItemsInSection: Int { get }
    func cellViewModel(forRowAt indexPath: IndexPath) -> MonthCollectionViewCellViewModel
}

public struct DefaultMonthCollectionViewModel: MonthCollectionViewModel {
    
    private let cellViewModels: [MonthCollectionViewCellViewModel]
    public var numberOfItemsInSection: Int {
        return cellViewModels.count
    }
    
    public init(months: [Month]) {
        cellViewModels = months.map { DefaultMonthCollectionViewCellViewModel(month: $0) }
    }
    
    public func cellViewModel(forRowAt indexPath: IndexPath) -> MonthCollectionViewCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

