//
//  MonthCollectionViewCellViewModel.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol MonthCollectionViewCellViewModel {
    
    var days: [Int] { get }
    var month: Int { get }
    var year: Int { get }
    func cellViewModel(forItemAt indexPath: IndexPath) -> DayCollectionViewCellViewModel
    func numberOfItem() -> Int
}

public struct DefaultMonthCollectionViewCellViewModel: MonthCollectionViewCellViewModel {
    public var year: Int
    public var month: Int
    public let days: [Int]
    private let cellViewModels: [DayCollectionViewCellViewModel]
    
    public init(month: Month) {
        days = month.days.map { $0.value }
        
        cellViewModels = month.days.map { DefaultDayCollectionViewCellViewModel(
            date: $0.referenceDate,
            isFromOtherMonth: !month.contains(day: $0),
            fontSize: 12
            )}
        self.month = month.value
        self.year = month.value
    }
    
    public func numberOfItem() -> Int {
        return cellViewModels.count
    }
    
    public func cellViewModel(forItemAt indexPath: IndexPath) -> DayCollectionViewCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

