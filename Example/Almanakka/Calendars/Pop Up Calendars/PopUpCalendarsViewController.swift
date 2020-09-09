//
//  PopUpCalendarsViewController.swift
//  Example
//
//  Created by Oscar Peredo on 2020/05/13.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit
import Almanakka


class PopUpCalendarsViewController: UIViewController {
    
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var calendarInstance : ALKCalendarPicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func simpleButtonPressed(_ sender: Any) {
        
        let theme = createThemeBlue()
        
        calendarInstance = ALKCalendarPicker(style: .popUpSimple, appearance: theme, selectionMode: .range)
        calendarInstance?.delegate = self
        
        calendarInstance?.show(in: self, animated: true)
    }
    
    
    @IBAction func simpleAltButtonPressed(_ sender: Any) {
        
        let theme = createThemeOrange()
        
        calendarInstance = ALKCalendarPicker(style: .popUpSimple, appearance: theme, selectionMode: .range)
        calendarInstance?.delegate = self
                
        calendarInstance?.show(in: self, animated: true)
    }
    
    @IBAction func detailedButtonPressed(_ sender: Any) {
        
        calendarInstance = ALKCalendarPicker(style: .popUpDetailed, selectionMode: .range)
        calendarInstance?.delegate = self

        calendarInstance?.show(in: self, animated: true)
    }
    
    @IBAction func detailedBlueButtonPressed(_ sender: Any) {
        
        let theme = createThemeBlue()
        
        calendarInstance = ALKCalendarPicker(style: .popUpDetailed, appearance: theme, selectionMode: .range)
        calendarInstance?.delegate = self
                
        calendarInstance?.show(in: self, animated: true)
    }
    
    @IBAction func detailedGreenButtonPressed(_ sender: Any) {
        
        let theme = createThemeGreen()

        calendarInstance = ALKCalendarPicker(style: .popUpDetailed, appearance: theme, selectionMode: .range)
        calendarInstance?.delegate = self
                
        calendarInstance?.show(in: self, animated: true)
    }
    
    @IBAction func detailedOrangeButtonPressed(_ sender: Any) {
        
        let theme = createThemeOrange()
        
        calendarInstance = ALKCalendarPicker(style: .popUpDetailed, appearance: theme, selectionMode: .range)
        calendarInstance?.delegate = self
                
        calendarInstance?.show(in: self, animated: true)
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
    
    private func createThemeOrange() -> ALKCalendarAppearance  {
        let theme = ALKCalendarAppearance()
        theme.calendarPrimaryColor = .systemOrange
        theme.calendarSecondaryColor = .systemOrange
        theme.calendarTintColor = .white
        theme.dayTextFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        theme.todayIndicatorType = .bevel(5)
        theme.todayIndicatorTextColor = .white
        theme.todayIndicatorBackgroundColor = UIColor.orange.withAlphaComponent(0.3)
        theme.belongsToDifferentMonthTextColor = UIColor.black.withAlphaComponent(0.3)
        theme.weekendTextColor = UIColor.orange.withAlphaComponent(0.8)
        
        return theme
    }
    
    private func createThemeGreen() -> ALKCalendarAppearance  {
        let theme = ALKCalendarAppearance()
        theme.calendarPrimaryColor = .systemGreen
        theme.calendarSecondaryColor = .systemGreen
        theme.calendarTintColor = .black
        theme.dayTextFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        theme.dayTextColor = UIColor.brown
        theme.todayIndicatorType = .square
        theme.todayIndicatorTextColor = .red
        theme.todayIndicatorBackgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        theme.belongsToDifferentMonthTextColor = UIColor.systemPink.withAlphaComponent(0.3)
        theme.weekendTextColor = UIColor.blue.withAlphaComponent(0.8)
        
        return theme
    }
    
}

extension PopUpCalendarsViewController: ALKCalendarPickerDelegate {
    
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
    
    func dateSelectionCanceled(calendarPicker calendar: ALKCalendarPicker) {
        selectedDateLabel.text = "canceled"
    }
}
