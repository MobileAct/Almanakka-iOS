//
//  CalendarComponents.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/19.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol CalendarComponents: Hashable {
    
    /// This will be the reference date from which all the other components will be created
    var referenceDate: Date { get }
    var unit: CalendarUnit { get }
    var value: Int { get }
    
    init(referenceDate: Date)
}

public protocol MonthProtocol {}
public protocol YearProtocol {}
public protocol WeekProtocol {}

public extension CalendarComponents where Self: MonthProtocol {
    var month: Month {
        return Month(referenceDate: referenceDate)
    }
}

public extension CalendarComponents where Self: YearProtocol {
    var year: Year {
        return  Year(referenceDate: referenceDate)
    }
}

public extension CalendarComponents where Self: WeekProtocol {
    var week: Week {
        return Week(referenceDate: referenceDate)
    }
}

public extension CalendarComponents {
    
    func advanced(by n: Int) -> Self {
        let advancedReferenceDate = referenceDate.adding(value: n, in: unit)
        return Self(referenceDate: advancedReferenceDate)
    }
    
    // A negative value means `self` is past compared to `other`
    func distance(to other: Self) -> Int {
        return referenceDate.distance(to: other.referenceDate, in: unit)
    }
}
