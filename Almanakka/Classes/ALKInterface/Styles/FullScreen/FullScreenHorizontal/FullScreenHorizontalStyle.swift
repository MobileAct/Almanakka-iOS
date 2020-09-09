//
//  HorizontalFullScreenViewController.swift
//  ALKInterface
//
//  Created by Kosuke Nishimura on 2020/05/21.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final class FullScreenHorizontalStyle: UIViewController, ALKPickerStyleProtocol {

    @IBOutlet private weak var calendarView: ALKCollectionViewCalendar!
    
    weak var selectionManager: ALKSelectionManager?
    weak var pickerInterfaceDelegate: ALKPickerInterfaceProtocol?
    
    var style: ALKCalendarAppearance = .Default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        calendarView.direction = .horizontal
        calendarView.style = style
        calendarView.selectionManager = selectionManager
    }
    
    @IBAction private func okButtonTapped(_ sender: Any) {
        pickerInterfaceDelegate?.okButtonPressed()
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        pickerInterfaceDelegate?.cancelButtonPressed()
    }
    
}
