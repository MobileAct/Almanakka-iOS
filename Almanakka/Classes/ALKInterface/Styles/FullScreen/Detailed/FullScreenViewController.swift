//
//  ViewController.swift
//  Example
//
//  Created by Kosuke Nishimura on 2019/12/23.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController, ALKPickerStyleProtocol {
    
    var selectionManager: ALKSelectionManager?
    var pickerInterfaceDelegate: ALKPickerInterfaceProtocol?
    
    private enum CollectionViewType: Int, CaseIterable {
        case weekday, days
    }
    
    @IBOutlet private weak var spacerView: UIView! {
        didSet {
            spacerView.layer.borderWidth = 1
            spacerView.layer.borderColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        }
    }
    @IBOutlet private weak var monthsAndYearsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var dismissButton: UIButton!
    
    //今だけ使いますのであとで消します
    private let curYear = Date.today.year
    private let curMonth = Date.today.month
    private let curDay = Date.today.day
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthsAndYearsLabel.text = "\(curYear)年\(curMonth)月\(curDay)日"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerXib(cellClass: HorizontalCalendarCollectionViewCell.self)
        collectionView.registerXib(cellClass: WeekdayCollectionViewCell.self)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextMonth(_ sender: Any) {
    }
    
    @IBAction func backMonth(_ sender: Any) {
    }
}

extension FullScreenViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CollectionViewType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = CollectionViewType(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .weekday:
            return 1
        case .days:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = CollectionViewType(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .weekday:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionViewCell.className, for: indexPath) as? WeekdayCollectionViewCell else {
                fatalError()
            }
            return cell
        case .days:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCalendarCollectionViewCell.className, for: indexPath) as? HorizontalCalendarCollectionViewCell else {
                fatalError()
            }
            return cell
        }
    }
}

extension FullScreenViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected: \(indexPath)")
//    }
    
}

extension FullScreenViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = CollectionViewType(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .weekday:
            return CGSize(width: collectionView.frame.width, height: 50)
        case .days:
            return CGSize(width: collectionView.frame.width, height: 350)
        }
        
    }
}


//今だけ使います。これからカスタマイズのn為にファイルを作ったら削除
func makeColor(for indexPath: IndexPath, view: DayCollectionViewCell, color: UIColor, firstWeekday: Weekday) {
    switch firstWeekday {
    case .sunday:
        switch indexPath.row {
        case 0, 6:
            view.dayLabelTextColor = color
        default:
            view.dayLabelTextColor = .black
        }
    case .monday:
        switch indexPath.row {
        case 5, 6:
            view.dayLabelTextColor = color
        default:
            view.dayLabelTextColor = .black
        }
    default:
        break
    }
}
