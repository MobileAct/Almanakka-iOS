//
//  DayCollectionViewCellViewModel.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public protocol DayCollectionViewCellViewModel {
    
    var day: Int { get }
    var weekday: Weekday { get }
    var isToday: Bool { get }
    var circleColor: UIColor { get }
    var fontSize: CGFloat { get }
    var selectionViewWidth: CGFloat { get }
    func dayColor() -> UIColor
}

public struct DefaultDayCollectionViewCellViewModel: DayCollectionViewCellViewModel {
    
    public let day: Int
    public let weekday: Weekday
    public let isToday: Bool
    public let circleColor: UIColor
    public let fontSize: CGFloat
    public let selectionViewWidth: CGFloat
    private let isFromOtherMonth: Bool
    
    public init(date: Date, isFromOtherMonth: Bool, circleColor: UIColor = .lightGray, fontSize: CGFloat) {
        self.day = date.day
        self.weekday = date.weekday
        self.isToday = Date.today == date
        self.isFromOtherMonth = isFromOtherMonth
        self.circleColor = circleColor
        self.fontSize = fontSize
        self.selectionViewWidth = fontSize * 3
    }
    
    public func dayColor() -> UIColor {
        if isFromOtherMonth {
            return .lightGray
        }
        
        switch weekday {
        case .sunday:
            return UIColor(hexString: "f60066")
        case .saturday:
            return UIColor(hexString: "64a2d6")
        default:
            return .black
        }
    }
}

