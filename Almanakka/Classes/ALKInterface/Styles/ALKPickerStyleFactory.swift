//
//  ALKPickerStyleFactory.swift
//  ALKInterface
//
//  Created by Kosuke Nishimura on 2020/05/25.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

struct ALKPickerStyleFactory {
    
    private let calendarStyle: ALKCalendarPicker.CalendarStyle
    private let calendarAppearance: ALKCalendarAppearance
    
    public init(style: ALKCalendarPicker.CalendarStyle, appearance: ALKCalendarAppearance) {
        self.calendarStyle = style
        self.calendarAppearance = appearance
    }
    
    func makeStyle() -> ALKPickerStyleProtocol {
        
        let vc: ALKPickerStyleProtocol
        
        switch calendarStyle {
        case .popUpSimple:
            vc = simplePickerStyleViewController()
        case .popUpDetailed:
            vc = popUpCalendarViewController()
        case .fullScreenHorizontal:
            vc = fullScreenHorizontalStyle()
        case .fullScreenVertical:
            vc = verticalFullScreenViewController()
        }
        
        return vc
    }
}

private extension ALKPickerStyleFactory {
    
    func simplePickerStyleViewController() -> SimplePickerStyleViewController {
        let vc = SimplePickerStyleViewController.instantiateFromStoryboard()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.style = calendarAppearance

        return vc
    }
    
    func popUpCalendarViewController() -> PopUpCalendarViewController {
        let vc = PopUpCalendarViewController.instantiateFromStoryboard()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.style = calendarAppearance
        
        return vc
    }
    
    func fullScreenHorizontalStyle() -> FullScreenHorizontalStyle {
        let vc = FullScreenHorizontalStyle.instantiateFromStoryboard()
        vc.style = calendarAppearance
        
        return vc
    }
    
    func verticalFullScreenViewController() -> VerticalFullScreenViewController {
        let vc = VerticalFullScreenViewController.instantiateFromStoryboard()
        vc.modalTransitionStyle = .crossDissolve
        vc.style = calendarAppearance
        
        return vc
    }
}
