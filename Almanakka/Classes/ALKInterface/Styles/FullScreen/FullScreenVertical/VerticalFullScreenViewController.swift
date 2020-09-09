//
//  VerticalFullScreenViewController.swift
//  ALKInterface
//
//  Created by Maharjan Binish on 2020/05/19.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class VerticalFullScreenViewController: UIViewController, ALKPickerStyleProtocol {
   
    var selectionManager: ALKSelectionManager?
    weak var pickerInterfaceDelegate: ALKPickerInterfaceProtocol?
    var style: ALKCalendarAppearance = .Default
    
    @IBOutlet private weak var calendarView: ALKCollectionViewCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        calendarView.direction = .vertical
        calendarView.delegate = self
        calendarView.isPagingEnabled = false
        calendarView.isStickyHeaderEnabled = true
        calendarView.selectionManager = selectionManager
        calendarView.style = style
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        pickerInterfaceDelegate?.cancelButtonPressed()
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        pickerInterfaceDelegate?.okButtonPressed()
    }
    
}

extension VerticalFullScreenViewController: ALKCollectionViewCalendarDelegate {
    
}
