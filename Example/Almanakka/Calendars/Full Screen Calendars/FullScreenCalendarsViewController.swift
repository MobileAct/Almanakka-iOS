//
//  FullScreenCalendarsViewController.swift
//  Example
//
//  Created by Oscar Peredo on 2020/05/13.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit
import Almanakka

class FullScreenCalendarsViewController: UIViewController {
    
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    private var picker: ALKCalendarPicker?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func horizontalButtonPressed(_ sender: Any) {
        
        picker = ALKCalendarPicker(style: .fullScreenHorizontal, appearance: createThemeBlue(), selectionMode: .range)
        picker?.delegate = self
        
        picker?.show(in: self, animated: true)
    }
    
    @IBAction func verticalButtonPressed(_ sender: Any) {
        
        picker = ALKCalendarPicker(style: .fullScreenVertical, appearance: createThemeBlue(), selectionMode: .range)
        picker?.delegate = self
        
        picker?.show(in: self, animated: true)
    }
    
    // MARK: - Styles
    
    private func createThemeBlue() -> ALKCalendarAppearance  {
        let theme = ALKCalendarAppearance()
        theme.calendarPrimaryColor = .systemBlue
        theme.calendarSecondaryColor = .systemBlue
        theme.calendarTintColor = .white
        theme.todayIndicatorType = .round
        theme.todayIndicatorTextColor = .white
        theme.todayIndicatorBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        theme.belongsToDifferentMonthTextColor = UIColor.gray.withAlphaComponent(0.5)
        theme.weekendTextColor = UIColor.red.withAlphaComponent(0.8)
        
        return theme
    }
}

extension FullScreenCalendarsViewController: ALKCalendarPickerDelegate {
    
    func dateSelectionFinishedWithResult(_ result : ALKSelectionManager.ALKSelectionResult, calendarPicker : ALKCalendarPicker) {
        
        let labelText : String
        
        switch result {
        case .selected(day: let date):
            labelText = date.toString()
        case .selectedRange(from: let from, to: let to):
            labelText = "\(from.toString()) to \(to.toString())"
        case .none:
            labelText = "none"
        }
        
        selectedDateLabel.text = labelText
    }
    
    func dateSelectionCanceled(calendarPicker: ALKCalendarPicker) {
        selectedDateLabel.text = "Date selection was canceled."
    }
    
}
