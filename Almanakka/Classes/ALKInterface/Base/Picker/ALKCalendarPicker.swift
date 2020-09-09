//
//  ALKCalendar.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/04/30.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public protocol ALKCalendarPickerDelegate : class {
    
    func dateSelectionFinishedWithResult(_ result : ALKSelectionManager.ALKSelectionResult, calendarPicker : ALKCalendarPicker)

    func dateSelectionCanceled(calendarPicker : ALKCalendarPicker)
}


internal protocol ALKPickerStyleProtocol : UIViewController {

    // Used to allow the picker to act as the delegate of an ALKMonthView
    // Styles must allow to have the manager object to be set by the picker,
    // this is to allow the selection code to be reused in all the styles
    var selectionManager: ALKSelectionManager? { get set }
    
    // Used to allow the picker to handle the 'ok' and 'cancel' actions
    // from interface elements that exist within a Calendar Picker Style
    var pickerInterfaceDelegate : ALKPickerInterfaceProtocol? { get set }
}


internal protocol ALKPickerInterfaceProtocol: class {
    
    func okButtonPressed()
    func cancelButtonPressed()
}

public class ALKCalendarPicker {
    
    public enum CalendarStyle {
        case popUpSimple
        case popUpDetailed
        case fullScreenHorizontal
        case fullScreenVertical
    }
    
    public weak var delegate : ALKCalendarPickerDelegate?
    
    
    // Calendar Setup
    private let calendarVC: ALKPickerStyleProtocol
    private let selectionManager: ALKSelectionManager

    
    public init(style : CalendarStyle, appearance: ALKCalendarAppearance = .Default, selectionMode : ALKSelectionManager.ALKSelectionMode = .single) {
        
        selectionManager = ALKSelectionManager(selectionMode: selectionMode)
        
        let pickerStyleFactory = ALKPickerStyleFactory(style: style, appearance: appearance)
        self.calendarVC = pickerStyleFactory.makeStyle()
        
        // The selection manager used by the calendar is handled by the picker itself
        self.calendarVC.selectionManager = selectionManager
        self.calendarVC.pickerInterfaceDelegate = self
    }
    
    public func show(in viewController : UIViewController, animated : Bool) {
        viewController.present(calendarVC, animated: animated)
    }
    
}

extension ALKCalendarPicker : ALKPickerInterfaceProtocol {
    
    func okButtonPressed() {
        
        
        // TODO: @Binish, i commented this outTemporarily commented out
        // TODO: This assumes the selected dates will always be in order, check if sorting them is required
//        let selectedDates = selectionManager.selectedDates()
//        var selectionResult : ALKSelectionManager.ALKSelectionResult? = nil
//        switch selectedDates.count {
//        case 0:
//            break
//        case 1:
//            guard let selectedFirstDate = selectedDates.first else { break }
//            selectionResult = .selected(day: selectedFirstDate)
//        default:
//            guard let selectedFirstDate = selectedDates.first, let selectedLastDate = selectedDates.last else { break }
//            selectionResult = .selectedRange(from: selectedFirstDate, to: selectedLastDate)
//        }
//
//        delegate?.dateSelectionFinishedWithResult(selectionResult ?? .none, calendarPicker: self)
            
        // Inform the delegate
        let selectionResult = selectionManager.calculateSelectionResult()
        delegate?.dateSelectionFinishedWithResult(selectionResult, calendarPicker: self)


        // Dismiss the picker
        calendarVC.dismiss(animated: true)
    }

    
    func cancelButtonPressed() {
        
        // Inform the delegate
        delegate?.dateSelectionCanceled(calendarPicker: self)
        
        // Dismiss the picker
        calendarVC.dismiss(animated: true)
    }
    
    
}
