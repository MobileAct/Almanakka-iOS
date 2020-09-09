//
//  InfiniteCollectionDataManager.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/13.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

class InfiniteCalendarDataManager {
    
    // MARK: Properties
    private var referenceYear: Year
    private let monthInYear = 12
    private var years: [Year]  = []
    
    private(set) var rangeOfYearFromCurrentIndex: Int = 50
    
    let indexForBackwardShift = 12
    var indexForForwardShift: Int {
        return (indexForBackwardShift * rangeOfYearFromCurrentIndex * 2) - 1
    }
    
    var totalNumberOfYears: Int {
        return years.count
    }
    
    var months: [Month] {
        years.flatMap { $0.months }
    }
    
    init(referenceDate: Date) {
        referenceYear = Year(referenceDate: referenceDate)
        initializeData()
    }
    
    // MARK: Properties
    func incrementYear() {
        let newCurrentYear = referenceYear.advanced(by: rangeOfYearFromCurrentIndex)
        let startIndex = newCurrentYear.value - rangeOfYearFromCurrentIndex
        let endIndex = newCurrentYear.value + rangeOfYearFromCurrentIndex
        
        generateYear(from: startIndex, to: endIndex)
    }
    
    func decrementYear() {
        let newCurrentYear = referenceYear.advanced(by: -rangeOfYearFromCurrentIndex)
        let startIndex = newCurrentYear.value - rangeOfYearFromCurrentIndex
        let endIndex = newCurrentYear.value + rangeOfYearFromCurrentIndex
        
        generateYear(from: startIndex, to: endIndex)
    }
    
    func displayYearChanged(to year: Year) {
        //TODO:
    }
}

// MARK: Data Initialization
extension InfiniteCalendarDataManager {
    
    private func initializeData() {
        let startIndex = referenceYear.value - rangeOfYearFromCurrentIndex
        let endIndex = referenceYear.value + rangeOfYearFromCurrentIndex
        
        generateYear(from: startIndex, to: endIndex)
    }
    
    private func generateYear(from startIndex: Int, to endIndex: Int) {
        years.removeAll()
        
        for index in (startIndex...endIndex) {
            var dateComponents = DateComponents()
            dateComponents.year = index
            dateComponents.month = 1
            dateComponents.day = 1
            let referenceDate = Calendar.current.date(from: dateComponents)
            years.append(Year(referenceDate: referenceDate!))
        }
    }
}
