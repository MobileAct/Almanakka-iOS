//
//  ViewCalendarsViewController.swift
//  Example
//
//  Created by Oscar Peredo on 2020/05/14.
//  Copyright © 2020 2020 Mobile Act, All rights reserved.
//

import UIKit
import Almanakka


class ViewCalendarsViewController: UIViewController {
    
    private enum SelectionType {
        case single
        case range
    }

    //MARK: IBOutlet
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var allowRangeSelectionSwitch: UISwitch!
    @IBOutlet private weak var alkCalendarView: ALKCollectionViewCalendar!
    
    @IBOutlet weak var selectedDateLabel: UILabel!
    //MARK: Properties
    private var selectedDates: [Day] = []
    private var selectionType: SelectionType = .single {
        didSet {
            updateSelectedLabel()
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
           dismiss(animated: true, completion: nil)
       }
    
    //MARK: Setup
    private func initialSetup() {
        setupCalendar()
        setupAllowRangeSelectionSwitch()
    }
    
    private func setupAllowRangeSelectionSwitch() {
        allowRangeSelectionSwitch.setOn(false, animated: false)
        allowRangeSelectionSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupCalendar() {
        alkCalendarView.style = createCalendarAppearance()
        alkCalendarView.direction = .horizontal
        alkCalendarView.selectionMode = .single
        alkCalendarView.delegate = self
    }
    
    private func createCalendarAppearance() -> ALKCalendarAppearance {
        let style = ALKCalendarAppearance()
        style.dayTextFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        style.weekendTextColor = UIColor.red
        style.belongsToDifferentMonthTextColor = UIColor.gray
        
        style.todayIndicatorType = .round
        style.todayIndicatorTextColor = .white
        style.todayIndicatorBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        style.weekdaysViewHeight = 40

        return style
    }
    
    @objc private func onSwitchValueChanged(_ sender: UISwitch) {

        selectedDates.removeAll()
        
        if sender.isOn {
            selectionType = .range
            alkCalendarView.selectionMode = .range
        } else {
            selectionType = .single
            alkCalendarView.selectionMode = .single
        }
    }
    
    private func updateSelectedLabel() {
        guard !selectedDates.isEmpty else {
            selectedDateLabel.text = "---"
            return
        }
        
        switch selectionType {
        case .single:
            let selectedDate = selectedDates.first!
            selectedDateLabel.text = selectedDate.toString()
        case .range:
            selectedDates.sort()
            let firstSelectedDate = selectedDates.first!
            let lastSelectedDate = selectedDates.last!
            selectedDateLabel.text = firstSelectedDate.toString() + " ~ " + lastSelectedDate.toString()
        }
    }
}

//MARK: ALKCollectionViewCalendarDelegate
extension ViewCalendarsViewController: ALKCollectionViewCalendarDelegate {
    func calendar(_ calendar: ALKCollectionViewCalendar, didSelectDateRanges dates: [Day]) {
        selectedDates = dates
        updateSelectedLabel()
    }

    func almanakka(_ almanakka: ALKCollectionViewCalendar, didScrollTo date: (year: Year, month: Month)) {
        yearLabel.text = "Year: \(date.year.value)"
        monthLabel.text = "Month: \(date.month.value)"
    }
}
