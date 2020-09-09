//
//  ALKMonthViewController.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/14.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

// Container View Controller used to show an ALKMonthView in a Page View Controller
class ALKMonthViewController: UIViewController {
    
    // TODO: Improve this
    // Configuration variables that must be set before the view did load method is called
    var selectionManager: ALKSelectionManager?
    var month : Month?
    var delegate : ALKMonthViewDelegate?
    var style : ALKCalendarAppearance?
    
    @IBOutlet weak var monthView: ALKMonthView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let style = self.style {
            self.monthView.style = style
        }

        self.monthView.month = month
        self.monthView.selectionManager = selectionManager
        self.monthView.delegate = delegate
        
        // TODO: set this with the style
        monthView.style.shouldShowWeekdays = false
    }
    
//    func configureForMonth(_ month : ALKCore.Month, delegate : ALKMonthViewDelegate, selectionManager : ALKSelectionManager?) {
//
//        monthView.month = month
//        monthView.selectionManager = selectionManager
//
//        monthView.style.shouldShowWeekdays = false
//    }
}
