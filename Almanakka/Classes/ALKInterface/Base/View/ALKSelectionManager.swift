//
//  ALKSelectionManager.swift
//  ALKInterface
//
//  Created by Kosuke Nishimura on 2020/05/27.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import Foundation

public class ALKSelectionManager {
    
    public enum ALKSelectionMode {
        case off
        case single
        case range
    }
    
    public enum ALKSelectionResult {
        case none
        case selected(day : Day)
        case selectedRange(from : Day, to : Day)
    }
    
    // TEMP START ----------------
    
    public enum ALKSelectionState {
        case notSelected
        case singleSelection
        case rangeStartSelection
        case rangeMiddleSelection
        case rangeEndSelection
    }
    
    public func appearanceForDay(_ day : Day) -> ALKSelectionState {
        
        switch selectionMode {
            
        case .off:
            // If selection is off, all days will show as not selected
            return .notSelected
        case .single:
            // In single selection
            if selectedDays.contains(day) {
                // Only the currently selected day will show as single selection
                return .singleSelection
            } else {
                // Any other days are not selected
                return .notSelected
            }
        case .range:
            // In range selection

            // TODO: Extract this so its only recalculated if the selected days array changes
            let orderedDays = selectedDays.sorted()

            if orderedDays.count == 1, let fromDay = orderedDays.first {
                if fromDay == day {
                    return .singleSelection
                } else {
                    return .notSelected
                }
            }
            else if orderedDays.count == 2, let fromDay = orderedDays.first, let toDay = orderedDays.last  {
                
                if day == fromDay {
                    return .rangeStartSelection
                }
                else if day > fromDay && day < toDay {
                    return .rangeMiddleSelection
                }
                else if day == toDay {
                    return .rangeEndSelection
                }
                else {
                    return .notSelected
                }
            } else {
                // Any other cases are treated as "not selected"
                return .notSelected
            }
        }
    }

    // The selected days array just has all of the "days" the user has manually selected
    private var selectedDays : Set<Day> = []
    
    // TODO: Ordered set can be extracted so that its only recalculated if the "selectedDays" arrange changes (on the "didSet" method)
//    private var orderedSelectedDays : Array<Day> = []
    
    // TODO: Change the name of this function, it could also be a computed variable but a function might be better?
    // The result is created depending on the current mode.
    public func calculateSelectionResult() -> ALKSelectionResult {
        
        // TODO: Extract this so its only recalculated if the selected days array changes
        let orderedDays = selectedDays.sorted()
       
        if orderedDays.isEmpty {
            return .none
        }
        else if orderedDays.count == 1, let selectedDay = orderedDays.first {
            return .selected(day: selectedDay)
        }
        else if orderedDays.count == 2, let fromDay = orderedDays.first, let toDay = orderedDays.last  {
            // A new selection range begins
            return .selectedRange(from: fromDay, to: toDay)
        }
        else {
            // This isn't handled
            return .none
        }
    }
    
    public func select(_ day : Day) {
        
        switch selectionMode {
  
        case .off:
            // selectedDays array isn't modified
            return
        case .single:
            // selectedDays array can only have one value at any given time
            
            if selectedDays.contains(day) {
                // Deselection
                selectedDays = []
            } else {
                // A different day is selected
                selectedDays = [day]
            }
        case .range:
            // selectedDays array can only have two value at any given time
            
            if selectedDays.isEmpty {
                // First insertion
                selectedDays.insert(day)
            }
            else if selectedDays.count == 2 {
                // A new selection range begins
                selectedDays = [day]
            }
            else if selectedDays.contains(day) {
                // If only the first cell is selected, tapping it again de-selects it.
                selectedDays.remove(day)
            }
            else {
                // Second Insertion
                selectedDays.insert(day)
            }
        }
    }
    

    
    // ---------------- TEMP END
    
    
    private var selectionStartDate: Day? = nil
    private var selectionEndDate: Day? = nil
    
    private let selectionMode: ALKSelectionMode
    
    init(selectionMode: ALKSelectionMode) {
        self.selectionMode = selectionMode
    }
    
    public func selectedDates() -> [Day] {
        
        let selectionResult = calculateSelectionResult()
        let result: [Day]
        switch selectionResult {
        case .selected(let day):
            result = [day]
        case .selectedRange(let firstDay, let lastDay):
            result = Day.daysBetween(firstDay, lastDay)
        default:
            result = []
        }
        return result
    }
}
