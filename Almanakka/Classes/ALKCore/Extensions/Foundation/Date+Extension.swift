//
//  Date+Extension.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public extension Date {
    
    static var calendar: Calendar = .current
    
    private var dateComponents: DateComponents {
        return Date.calendar.dateComponents([.weekday, .day, .weekOfMonth, .weekOfYear, .month, .year], from: self)
    }
    
    /// today
    static let today = Date()
    
    /// One minute in second
    static let oneMinute = 60
    
    /// One hour in second
    static let oneHour = 60 * 60
    
    /// One day in second
    static let oneDay = 60 * 60 * 24
    
    /// One week in second
    static let oneWeek = 60 * 60 * 24 * 7
    
    /// day of `self`
    var day: Int {
        return dateComponents.day!
    }
    
    /// index of the week which contains `self` in month
    var weekOfMonth: Int {
        return dateComponents.weekOfMonth!
    }
    
    /// index of the week which contains `self` in year
    var weekOfYear: Int {
        return dateComponents.weekOfYear!
    }
    
    /// month of `self`
    var month: Int {
        return dateComponents.month!
    }
    
    /// year of `self`
    var year: Int {
        return dateComponents.year!
    }
    
    /// weekday index of `self`.
    /// the index of Sunday is zero.
    var weekdayIndex: Int {
        return dateComponents.weekday! - 1
    }
    
    /// weekday of `self`
    var weekday: Weekday {
        return Weekday(rawValue: weekdayIndex)
    }
    
    /// number of days in month which contains `self`
    var numberOfDaysInMonth: Int {
        return Date.calendar.range(of: .day, in: .month, for: self)!.count
    }
    
    /// Returns the localized weekday symbol of given day
    func weekday(useShortSymbol: Bool) -> String {
        let symbols = useShortSymbol ? Date.calendar.shortWeekdaySymbols : Date.calendar.weekdaySymbols
        return symbols[weekdayIndex]
    }
}

public extension Date {
    
    /// Returns a new `Date` instance which is made by adding `value` in the given `unit` to `self`.
    /// For example, if `value` is `1` and `unit` is `.month` then return a date one month later from `self`
    /// - Parameters:
    ///   - value: a value to be added
    ///   - unit: the unit of the given value
    func adding(value: Int, in unit: CalendarUnit) -> Date {
        switch unit {
        case .day:
            return Date.calendar.date(byAdding: .day, value: value, to: self)!
        case .week:
            return Date.calendar.date(byAdding: .day, value: value * 7, to: self)!
        case .month:
            return Date.calendar.date(byAdding: .month, value: value, to: self)!
        case .year:
            return Date.calendar.date(byAdding: .year, value: value, to: self)!
        }
    }
    
    /// Returns the distance from `self` to `other`.
    /// A negative value means `self` is past comparing to `other`
    /// - Parameters:
    ///   - other: a date to be compared.
    ///   - unit: the unit of distance
    func distance(to other: Date, in unit: CalendarUnit) -> Int {
        let component: DateComponents
        switch unit {
        case .day:
            component = Date.calendar.dateComponents([.day], from: other, to: self)
            return component.day!
        case .week:
            component = Date.calendar.dateComponents([.day], from: other, to: self)
            return component.day! / 7
        case .month:
            component = Date.calendar.dateComponents([.month], from: other, to: self)
            return component.month!
        case .year:
            component = Date.calendar.dateComponents([.year], from: other, to: self)
            return component.year!
        }
    }
}

public extension Date {
    
    /// Returns if `self` and the given other date is in the same month
    /// - Parameter date: other date to be compared.
    func isSameMonth(with date: Date) -> Bool {
        return self.month == date.month
    }
}


extension Date {
    
    /// Converts the `self` in string
    /// - Parameter format: format for the result string
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
