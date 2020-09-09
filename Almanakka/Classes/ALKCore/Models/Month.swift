//
//  Month.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/18.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public struct Month: CalendarComponents, YearProtocol {

    public let referenceDate: Date
    public let unit: CalendarUnit = .month
    
    public var value: Int {
        return referenceDate.month
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
    
    public var numberOfDays: Int {
        return referenceDate.numberOfDaysInMonth
    }
    
    public var weeks: [Week] {
        let distanceFromFirstDay = referenceDate.day - 1
        let firstDay = referenceDate.adding(value: -distanceFromFirstDay, in: .day)
        
        let weeks = (0...5).map { Week(referenceDate: firstDay.adding(value: $0, in: .week)) }
        
        if isExcludingWeeksBeforeAndAfter {
            return weeks.filter { contains(week: $0) }
        } else {
            return weeks
        }
    }
    
    public var days: [Day] {
        return weeks.flatMap { $0.days }
    }
    
    /// Checks if this month contains this `day` or not
    public func contains(day: Day) -> Bool {
        referenceDate.month == day.month.value && referenceDate.year == day.year.value
    }
    
    /// Checks if this month contains this `week` or not
    public func contains(week: Week) -> Bool {
        guard let firstDayOfWeek = week.days.first, let lastDayOfWeek = week.days.last else {
            return false
        }
        
        return contains(day: firstDayOfWeek) || contains(day: lastDayOfWeek)
        
    }
}

extension Month: Comparable, Equatable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year > rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year < rhs.referenceDate.year {
            return true
        } else {
            return lhs.referenceDate.month < rhs.referenceDate.month
        }
    }
    
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year > rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year < rhs.referenceDate.year {
            return true
        } else {
            return lhs.referenceDate.month <= rhs.referenceDate.month
        }
    }

    public static func >= (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year < rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year > rhs.referenceDate.year {
            return true
        } else {
            return lhs.referenceDate.month >= rhs.referenceDate.month
        }
    }

    public static func > (lhs: Self, rhs: Self) -> Bool {
        if lhs.referenceDate.year < rhs.referenceDate.year {
            return false
        } else if lhs.referenceDate.year > rhs.referenceDate.year {
            return true
        } else {
            return lhs.referenceDate.month > rhs.referenceDate.month
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.referenceDate.month == rhs.referenceDate.month
            && lhs.referenceDate.year == rhs.referenceDate.year
    }
}

public extension Month {
    
    var totalNumberOfDays: Int {
        return days.filter { contains(day: $0) }.count
    }
    
    var totalNumberOfWeek: Int {
        return weeks.filter { contains(week: $0) }.count
    }
    
    var firstDay: Day {
        return days.first { contains(day: $0) }!
    }
    
    var lastDay: Day {
        return days.last { contains(day: $0) }!
    }
    
    var firstWeekDayOftheMonth: Int {
        let startOfTheMonth = self.firstDay
        let weekDay = startOfTheMonth.weekDay
        let firstWeekDayOfTheMonth = weekDay.rawValue
        return firstWeekDayOfTheMonth
    }
    
    /// Returns the day of particular weekday(eg: sunday,monday) at given position(eg: 1,2)
    /// if the weekDay doesn`t exist at the given postion, return nil
    /// - Parameters:
    ///   - weekDay: weekday to find
    ///   - position: position to week day
    func day(of weekDay: Weekday, at position: Int) -> Day? {
        let allDaysOfMonth = days.filter { contains(day: $0) }
        let allWeekDays = allDaysOfMonth.filter { $0.weekDay == weekDay }
        
        if position <= allWeekDays.count {
            return allWeekDays[position - 1]
        }
        
        return nil
    }
}
