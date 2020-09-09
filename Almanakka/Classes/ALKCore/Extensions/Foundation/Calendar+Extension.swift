//
//  Calendar+Extension.swift
//  Core
//
//  Created by Kosuke Nishimura on 2019/12/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public extension Calendar {
    
    static var japanCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ja_JP")
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return calendar
    }
    
    static var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }
}
