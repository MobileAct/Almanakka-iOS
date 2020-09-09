//
//  Week.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/18.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public struct Week: CalendarComponents, MonthProtocol, YearProtocol {
    
    public let referenceDate: Date
    public let unit: CalendarUnit = .week
    
    public var value: Int {
        return referenceDate.weekdayIndex
    }
    
    public init(referenceDate: Date) {
        self.referenceDate = referenceDate
    }
    
    public var days: [Day] {
        
        let startIndex = -referenceDate.weekdayIndex
        let endIndex = startIndex + 6
        
        return (startIndex...endIndex).map { Day(referenceDate: referenceDate.adding(value: $0, in: .day))}
    }
    
    /// Returns if `self` contains `day` or not
    public func contains(day: Day) -> Bool {
        return self.days.contains(day)
    }
    
}


extension Week {
    
    public var firstDay: Day {
        return days.first!
    }
    
    public var lastDay: Day {
        return days.last!
    }
    
    public var indexOfTheWeekOfTheYear: Int {
        return referenceDate.weekOfYear
    }
    
    public var indexOfWeekOfTheMonth: Int {
        return referenceDate.weekOfMonth
    }
}
