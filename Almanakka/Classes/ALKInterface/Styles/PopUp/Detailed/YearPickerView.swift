//
//  YearPickerView.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

final public class YearPickerView: UIView {
    
    @IBOutlet private weak var pickerView: UIPickerView!
    private let years = Array(1970...2100)
    var doneTapped: ((Int) -> Void)!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let currentIndex = years.firstIndex(of: Date.today.year)
        pickerView.selectRow(currentIndex!, inComponent: 0, animated: false)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        let selectedYear = years[selectedIndex]
        doneTapped(selectedYear)
    }
}

extension YearPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row])
    }
}

extension YearPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
}
