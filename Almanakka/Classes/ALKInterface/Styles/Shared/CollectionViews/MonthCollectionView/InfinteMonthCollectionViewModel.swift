//
//  InfinteMonthCollectionViewModel.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol InfiniteMonthsCollectionViewModel {
    
    var numberOfItemsInSection: Int { get }
    var initialDisplayIndex: IndexPath { get }
    var indexForForwardShift: IndexPath { get }
    func cellViewModel(forRowAt indexPath: IndexPath) -> MonthCollectionViewCellViewModel
    func increaseYear()
    func decreaseYear()
    
}

public struct DefaultInfiniteMonthsCollectionViewModel: InfiniteMonthsCollectionViewModel {
    public var cellViewModels: [MonthCollectionViewCellViewModel] {
        dataManager.months.map { DefaultMonthCollectionViewCellViewModel(month: $0) }
    }
    
    private let dataManager: InfiniteCalendarDataManager
    
    public var numberOfItemsInSection: Int {
        return cellViewModels.count
    }
    
    public var indexForForwardShift: IndexPath {
//        return dataManager.indexForForwardShift
        fatalError()
    }
    
    public var initialDisplayIndex: IndexPath {
//        return dataManager.initialDisplayIndex
        fatalError()
    }
    
    public func cellViewModel(forRowAt indexPath: IndexPath) -> MonthCollectionViewCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    init(dataManager: InfiniteCalendarDataManager) {
        self.dataManager = dataManager
    }
    
    public func increaseYear() {
        dataManager.incrementYear()
    }
    
    public func decreaseYear() {
        dataManager.decrementYear()
    }
    
}
