//
//  PopUpCalendarViewController.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public final class PopUpCalendarViewController: UIViewController, ALKPickerStyleProtocol {
    
    var selectionManager: ALKSelectionManager?
    var pickerInterfaceDelegate: ALKPickerInterfaceProtocol?
    
    
    @IBOutlet private weak var yearViewContainer: UIView!
    @IBOutlet private weak var monthsContainerView: UIView!
    
    @IBOutlet private weak var popUpContainerView: UIView!
    @IBOutlet private weak var yearView: UIView!
    @IBOutlet private weak var yearDisplayLabel: UILabel!
    @IBOutlet private weak var pickerViewContainer: UIView!
    @IBOutlet private weak var pickerViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet private weak var alkView: ALKCollectionViewCalendar!
    
    private let monthsView = MonthsView.instantiateFromXib()
    private let pickerView = YearPickerView.instantiateFromXib()
    
    private var years = [Year(referenceDate: .today)]
    private var isFirstLoad = true
    private let indexOfCurrentYear = 0
    
    public var style: ALKCalendarAppearance = ALKCalendarAppearance.Default
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 初めての一回だけセットする
        if isFirstLoad {
            isFirstLoad = !isFirstLoad
            yearDisplayLabel.text = "\(years[0].value)年"
            togglePicker(show: false, with: 0.0)
        }

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStyle()
    }
    
    // Picker表示関連
    @objc private func yearLabelTapped() {
        togglePicker(show: true)
    }
    
    private func monthsCellTapped(index: Int)  {
        alkView.scrollToIndex(section: index)
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        pickerInterfaceDelegate?.okButtonPressed()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        pickerInterfaceDelegate?.cancelButtonPressed()
    }
    
}

extension PopUpCalendarViewController {
    
    private func initialSetup() {
        setupLayerProperties()
        monthsDisplayLabelSetup()
        pickerViewSetup()
        setupALKView()
        setupStyle()
    }
    
    private func setupStyle() {
        yearViewContainer.backgroundColor = style.calendarPrimaryColor
        monthsContainerView.backgroundColor = style.calendarSecondaryColor
        yearDisplayLabel.textColor = style.calendarTintColor
        monthsView.textColor = style.calendarTintColor
    }
    
    private func setupLayerProperties() {
        popUpContainerView.layer.cornerRadius = 2
    }
    
    private func monthsDisplayLabelSetup() {
        monthsContainerView.addFillingSubview(monthsView)
        
        monthsView.tapAction = monthsCellTapped(index:)
    }
    
    private func pickerViewSetup() {
        pickerViewContainer.addFillingSubview(pickerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(yearLabelTapped))
        yearView.addGestureRecognizer(tapGesture)
        
        pickerView.doneTapped = pickerDoneWasPressed(picked:)
    }
    
    private func setupALKView() {
        alkView.style = style
        alkView.backgroundColor = UIColor.clear
        alkView.direction = .horizontal
        alkView.delegate = self
        alkView.selectionManager = selectionManager
    }
}

// MARK: Picker View
extension PopUpCalendarViewController {
    
    private func togglePicker(show: Bool, with duration: TimeInterval = 0.2) {
        pickerViewBottomConstraints.constant = show ? 0 : pickerViewContainer.frame.height
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func pickerDoneWasPressed(picked year: Int) {
        togglePicker(show: false)
        
        let currentYear = years[indexOfCurrentYear]
        let currentYearValue = currentYear.value
        let pickedYear = year
        
        let yearDifference = pickedYear - currentYearValue
        
        let selectedYearToBeDisplayed = currentYear.advanced(by: yearDifference)
        years = [selectedYearToBeDisplayed]
        
        yearDisplayLabel.text = "\(selectedYearToBeDisplayed.value)年"
        alkView.changeDisplayYear(year: selectedYearToBeDisplayed)
    }
}

extension PopUpCalendarViewController: ALKCollectionViewCalendarDelegate {
    public func almanakka(_ almanakka: ALKCollectionViewCalendar, didScrollTo date: (year: Year, month: Month)) {
        let zeroBasedMonthIndex = (date.month.value - 1) % alkView.numberOfMonthsInYear
        let scrollMonthIndex = IndexPath(row: zeroBasedMonthIndex, section: 0)
        
        yearDisplayLabel.text = "\(date.year.value)年"
        monthsView.selectMonth(at: scrollMonthIndex, animated: false)
    }

}
