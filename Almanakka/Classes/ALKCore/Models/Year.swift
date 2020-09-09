//
//  Year.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/18.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public struct Year: CalendarComponents {
    
    public let referenceDate: Date
    public let unit: CalendarUnit = .year
    
    public var value: Int {
        return referenceDate.year
    }
    
    private let isExcludingWeeksBeforeAndAfter: Bool
    
    public init(referenceDate: Date) {
        self.referenceDate = referenceDate
        self.isExcludingWeeksBeforeAndAfter = false
    }
    
    public init(referenceDate: Date, isExcludingWeeksBeforeAndAfter: Bool = false) {
        self.referenceDate = referenceDate
        self.isExcludingWeeksBeforeAndAfter = isExcludingWeeksBeforeAndAfter
    }
    
    public var months: [Month] {
        let startIndex = 1 - referenceDate.month
        let endIndex = startIndex + 11
        
        return (startIndex...endIndex).map { Month(referenceDate: referenceDate.adding(value: $0, in: .month),
                                                   isExcludingWeeksBeforeAndAfter: isExcludingWeeksBeforeAndAfter) }
    }
    
    /// Returns if `self` contains `day` or not
    public func contains(day: Day) -> Bool {
        return referenceDate.year == day.year.value
    }
    
    /// Returns if `self` contains `week` or not
    public func contains(week: Week) -> Bool {
        guard let firstDayOfWeek = week.days.first, let lastDayOfWeek = week.days.last else {
            return false
        }
        
        return contains(day: firstDayOfWeek) || contains(day: lastDayOfWeek)
    }
    
    /// Returns if `self` contains `month` or not
    public func contains(month: Month) -> Bool {
        return referenceDate.year == month.year.value
    }
}

extension Year: Comparable, Equatable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.year < rhs.referenceDate.year
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.year <= rhs.referenceDate.year
    }
    
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.year >= rhs.referenceDate.year
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.year > rhs.referenceDate.year
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.year == rhs.referenceDate.year
    }
}

public extension Year {
    var isLeapYear: Bool {
        return (( value % 100 != 0) && ( value % 4 == 0)) || value % 400 == 0
    }
}
