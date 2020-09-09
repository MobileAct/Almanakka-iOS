//
//  Weekday.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/18.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public enum Weekday: Int, CaseIterable {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

public extension Weekday {
    
    /// Initialize `Weekday` with the given `rawValue`.
    /// the given `rawValue` will be converted to an integer modulo 7.
    init(rawValue: Int) {
        switch (rawValue % 7) {
        case 0:
            self = .sunday
        case 1, -6:
            self = .monday
        case 2, -5:
            self = .tuesday
        case 3, -4:
            self = .wednesday
        case 4, -3:
            self = .thursday
        case 5, -2:
            self = .friday
        case 6, -1:
            self = .saturday
        default:
            fatalError()
        }
    }
    
    /// Returns a localized string symbol of `self`.
    /// ex) "Sunday", "Sun"
    /// - Parameter useShortSymbol: determines if the returned string is a short symbol or not.
    func symbol(useShortSymbol: Bool) -> String {
        let calendar = Calendar.current
        let symbols = useShortSymbol ? calendar.shortWeekdaySymbols : calendar.weekdaySymbols
        
        return symbols[self.rawValue]
    }
    
    /// Returns all weekday symbols.
    /// - Parameters:
    ///   - firstWeekday: the first weekday of the returned string array.
    ///   - useShortSymbols: determines if the returned string is a short symbol or not.
    static func weekdaySymbols(firstWeekday: Self = .sunday, useShortSymbols: Bool) -> [String] {
        let startIndex = firstWeekday.rawValue
        let endIndex = startIndex + 6
        let weekdays: [Weekday] = (startIndex...endIndex).map { Weekday(rawValue: $0) }
        return weekdays.map { $0.symbol(useShortSymbol: useShortSymbols) }
    }
}
