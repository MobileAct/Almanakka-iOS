//
//  ALKCalendarAppearance.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/13.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol ALKCalendarAppearanceParameter { }

// Appearance class used to customize the way a calendar looks
// This class should be subclassed for calendars that require additional parameters
public class ALKCalendarAppearance {
    
    public static let Default: ALKCalendarAppearance = ALKCalendarAppearance()
    
    public init() {}
    //MARK: Calendar Setting
    public var calendarPrimaryColor = UIColor.white
    public var calendarSecondaryColor = UIColor.white
    public var calendarTintColor = UIColor.black
    
    //MARK: Day Setting
    public var dayTextColor = UIColor.black
    public var dayCellBackgroundColor = UIColor.clear
    public var dayCellBorderColor = UIColor.clear
    public var dayCellBorderWidth = CGFloat(0.0)
    public var dayTextFont = UIFont.systemFont(ofSize: 17)
    
    //MARK: Today indicator setting:
    public var todayIndicatorType = TodayIndicatorShape.bevel(4.0)
    public var todayIndicatorTextColor = UIColor.red
    public var todayIndicatorBackgroundColor = UIColor.clear
    
    // TODO: Not implemented
//    public var todayIndicatorBorderColor = UIColor.red
//    public var todayIndicatorBorderWidth = CGFloat(1.0)
//    public var todayIndicatorBorderRadius = CGFloat(0.0)
    
    //MARK: Weekend Setting
    public var weekendTextColor = UIColor.black
    
    // Excluding weeks before and after setting:
    public var belongsToDifferentMonthTextColor = UIColor.black
    
    // Common setting:
    public var firstWeekday = FirstWeekday.sunday
    
    // Selected Cell setting:
    public var selectedCellBorderColor = UIColor.yellow.cgColor
    public var selectedCellBorderWidth = CGFloat(3.0)
    public var selectedCellColor = UIColor.clear
    public var selectedCellTextColor = UIColor.black
    public var selectedCellTodayColor = UIColor.clear
    
    //WeekDays Header Setting
    public var shouldShowWeekdays: Bool = true
    public var weekdaysViewHeight: CGFloat = 30
}

// MARK:- Parameter Types
public extension ALKCalendarAppearance {
    
    enum TodayIndicatorShape: ALKCalendarAppearanceParameter {
        case round
        case square
        case bevel(CGFloat)
        
        var isRound: Bool {
            switch self {
            case .round:
                return true
            default:
                return false
            }
        }
    }
    
    enum FirstWeekday: ALKCalendarAppearanceParameter {
        case sunday
        case monday
    }
    
    struct CalendarColor: ALKCalendarAppearanceParameter {
        public let primaryColor: UIColor
        public let secondaryColor: UIColor
        public let tintColor: UIColor
    }
    
    struct DayCellAppearance: ALKCalendarAppearanceParameter {
        public let textColor: UIColor
        public let textFont: UIFont
        public let backgroundColor: UIColor
        public let borderColor: UIColor
        public let borderWidth: CGFloat
    }
    
    struct WeekdayCellAppearance: ALKCalendarAppearanceParameter {
        public let weekendTextColor: UIColor
        public let firstWeekday: FirstWeekday
    }
    
    struct MonthCellAppearance: ALKCalendarAppearanceParameter {
        public let dayInDifferentMonthTextColor: UIColor
    }
    
    struct TodayIndicatorAppearance: ALKCalendarAppearanceParameter {
        public let indicatorShape: TodayIndicatorShape
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let borderColor: UIColor
        public let borderWidth: CGFloat
//        public let borderRadius: CGFloat
    }
    
    struct SelectionHighlightAppearance: ALKCalendarAppearanceParameter {
        public let borderColor: UIColor
        public let borderWidth: CGFloat
        public let backgroundColor: UIColor
        public let textColor: UIColor
        public let todayColor: UIColor
    }
    
    struct HeaderAppearance: ALKCalendarAppearanceParameter {
        public let shouldShowWeekdays: Bool
        public let weekdaysViewHeight: CGFloat
    }
}
