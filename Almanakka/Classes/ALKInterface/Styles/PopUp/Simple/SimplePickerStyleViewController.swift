//
//  SimplePickerViewController.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class SimplePickerStyleViewController: UIViewController, ALKPickerStyleProtocol {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    

    // Required to conform to the ALKPickerStyleProtocol
    weak var selectionManager: ALKSelectionManager?
    weak var pickerInterfaceDelegate: ALKPickerInterfaceProtocol?
    
    public var style: ALKCalendarAppearance = ALKCalendarAppearance.Default
    
    private let monthComponents = Calendar.current.monthSymbols


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load today's calendar page
        calendarPageViewController.resetViewControllers()
        
        yearLabel.textColor = style.calendarPrimaryColor
//        monthLabel.textColor = style.calendarSecondaryColor
        
        cancelButton.setTitleColor(style.calendarPrimaryColor, for: .normal)
        okButton.setTitleColor(style.calendarPrimaryColor, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateMonthYearDisplay()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("SimplePickerStyleViewController: Cancel button pressed.")
        self.pickerInterfaceDelegate?.cancelButtonPressed()
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        print("SimplePickerStyleViewController: OK button pressed.")
        self.pickerInterfaceDelegate?.okButtonPressed()
    }
    

    // MARK: - Calendar Page
    
    // Calendar Page View Controller
    weak var calendarPageViewController : ALKCalendarPageViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SimpleCalendarPageVCSegue", let calendarPageVC = segue.destination as? ALKCalendarPageViewController {
            
            calendarPageViewController = calendarPageVC
            calendarPageViewController.style = style
            calendarPageViewController.selectionManager = selectionManager
            
            calendarPageViewController.calendarDelegate = self
        }
    }
    
    private func updateMonthYearDisplay() {
        
        self.monthLabel.text = String(monthComponents[calendarPageViewController.displayedMonth.value - 1])
        self.yearLabel.text = String(calendarPageViewController.displayedMonth.year.value)
    }

}

// MARK: - ALKCalendarPageViewControllerDelegate
extension SimplePickerStyleViewController: ALKCalendarPageViewControllerDelegate {
    
    func pageChanged() {
        print("SimplePickerViewController -> ALKCalendarPageViewControllerDelegate: Page Changed")
        
        updateMonthYearDisplay()
    }
    
}
