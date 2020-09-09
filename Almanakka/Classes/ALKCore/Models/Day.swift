//
//  Day.swift
//  Core
//
//  Created by Kosuke Nishimura on 2020/03/08.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public struct Day: CalendarComponents, MonthProtocol, YearProtocol, WeekProtocol {

    public let referenceDate: Date
    
    public let unit: CalendarUnit = .day
    
    public var value: Int {
        return referenceDate.day
    }
    
    var weekDay: Weekday {
        referenceDate.weekday
    }
    
    public init(referenceDate: Date) {
        self.referenceDate = referenceDate
    }
}

extension Day: Comparable, Equatable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year > rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year < rhs.referenceDate.year {
            return true
        } else {
            if lhs.referenceDate.month > rhs.referenceDate.month {
                return false
            } else if lhs.referenceDate.month < rhs.referenceDate.month {
                return true
            } else {
                return lhs.referenceDate.day < rhs.referenceDate.day
            }
        }
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year > rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year < rhs.referenceDate.year {
            return true
        } else {
            if lhs.referenceDate.month > rhs.referenceDate.month {
                return false
            } else if lhs.referenceDate.month < rhs.referenceDate.month {
                return true
            } else {
                return lhs.referenceDate.day <= rhs.referenceDate.day
            }
        }
    }

    public static func >= (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year < rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year > rhs.referenceDate.year {
            return true
        } else {
            if lhs.referenceDate.month < rhs.referenceDate.month {
                return false
            } else if lhs.referenceDate.month > rhs.referenceDate.month {
                return true
            } else {
                return lhs.referenceDate.day >= rhs.referenceDate.day
            }
        }
    }

    public static func > (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year < rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year > rhs.referenceDate.year {
            return true
        } else {
            if lhs.referenceDate.month < rhs.referenceDate.month {
                return false
            } else if lhs.referenceDate.month > rhs.referenceDate.month {
                return true
            } else {
                return lhs.referenceDate.day > rhs.referenceDate.day
            }
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.day == rhs.referenceDate.day
            && lhs.referenceDate.month == rhs.referenceDate.month
            && lhs.referenceDate.year == rhs.referenceDate.year
    }
}

extension Day {
    
    /// Returns the array of days between the two input days.[Note: firstDay and secondDay are not included in result]
    /// - Parameters:
    ///   - dayFirst: Date that makes up the first part of the range
    ///   - daySecond: Date that makes up the second part of the range
    public static func daysBetween(_ firstDay: Day, _ secondDay: Day) -> [Day] {
        let numberOfDays = secondDay.distance(to: firstDay)
        return (0...numberOfDays).map { Day(referenceDate: firstDay.referenceDate.adding(value: $0, in: .day)) }
    }
    
    public var isToday: Bool {
        let isSameDay = referenceDate.day == Date.today.day
        let isSameMonth = referenceDate.month == Date.today.month
        let isSameYear = referenceDate.year == Date.today.year
        return isSameDay && isSameMonth && isSameYear
    }
    
    public var isTomorrow: Bool {
        return referenceDate == Date.today.adding(value: 1, in: .day)
    }
    
    public var isYesterday: Bool {
        return referenceDate == Date.today.adding(value: -1, in: .day)
    }
    
    public var isWeekend: Bool {
        return weekDay == .sunday || weekDay == .saturday
    }
    
    public var isWeekday: Bool {
        return !isWeekend
    }
    
    public var isInFuture: Bool {
        return referenceDate > Date.today
    }
    
    public var isInPast: Bool {
        return referenceDate < Date.today
    }
    
    public func toString(format: String = "yyyy-MM-dd") -> String {
        return referenceDate.toString(format: format)
    }
}
