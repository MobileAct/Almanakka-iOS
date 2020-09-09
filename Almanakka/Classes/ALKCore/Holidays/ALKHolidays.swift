//
//  ALKHolidays.swift
//  ALKCore
//
//  Created by Oscar Peredo on 2020/05/11.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation



public struct ALKHoliday {
    
    public let date : Date
    public let name : String
    public let nameEng : String?
}

public protocol ALKHolidaysParser {
    
    func parseHolidays() -> [Day : ALKHoliday]
    
}

public final class ALKHolidays {
    

    public let holidays : [Day : ALKHoliday]
    
    init(parser : ALKHolidaysParser) {
        holidays = parser.parseHolidays()
    }
    
    public func holidayForDate(_ date : Date) -> ALKHoliday? {
        
        let comparisonDate = Day(referenceDate: date)
        return holidays[comparisonDate]
    }
}
