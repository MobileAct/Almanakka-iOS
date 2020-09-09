//
//  ALKDayCell.swift
//  Almanakka
//
//  Created by Rogozhkin Vladimir on 2020/04/20.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit



open class ALKDayCell: UICollectionViewCell {
    
    enum ALKDayCellSelectionState {
        case single
        case start
        case middle
        case end
        case none
    }
    
    // The text label (30)
    private var textLabel: UILabel?
    
    // Single Selection View
    private var singleSelectionView: UIView?
    
    // Range Selection Views
    private var rangeSelectionHeadView: UIView?
    private var rangeSelectionMiddleView: UIView?
    private var rangeSelectionTailView: UIView?
    
    // The today indicator
    private var todayIndicatorView: UIView?
    
    // Selection View Properties
    private let circleRatio: CGFloat = 0.75
    private let startPointRatio: CGFloat = 0.125
//    private let startPointRatio: CGFloat = 0.25

    
    
    // TODO: This is wrong, it should come directly from the collection view
    private var style: ALKCalendarAppearance = ALKCalendarAppearance.Default
    
    
    // Internal Variables
    private var day: Int = 0
    private var isToday: Bool = false
    private var belongsToCurrentMonth: Bool = false
    private var isWeekend: Bool = false
    private var selectionState: ALKDayCellSelectionState = .none
    
    
    // MARK: - Setup
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let smallestSide = min(frame.width, frame.height)
        let width = smallestSide * circleRatio

        rangeSelectionHeadView?.roundCorners(corners: [.topLeft, .bottomLeft], radius: width / 2)
        rangeSelectionTailView?.roundCorners(corners: [.topRight, .bottomRight], radius: width / 2)
    }
    
    func configureSingleSelectionView() {
        
        if (singleSelectionView == nil) {
            
            let smallestSide = min(frame.width, frame.height)
            let circleDiameter = smallestSide * circleRatio
            
            singleSelectionView = UIView()
            singleSelectionView?.layer.cornerRadius = circleDiameter / 2
            
            singleSelectionView?.translatesAutoresizingMaskIntoConstraints = false

            
            singleSelectionView!.isHidden = true
            
            
            addSubview(singleSelectionView!)
            
            NSLayoutConstraint.activate([
                singleSelectionView!.centerXAnchor.constraint(equalTo: centerXAnchor),
                singleSelectionView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                singleSelectionView!.widthAnchor.constraint(equalToConstant: circleDiameter),
                singleSelectionView!.heightAnchor.constraint(equalToConstant: circleDiameter)
            ])

        }
       
        singleSelectionView?.backgroundColor = .lightGray
    }
    
    func configureRangeSelectionViews() {
        
        let smallestSide = min(frame.width, frame.height)
        let startingX = smallestSide * startPointRatio
        
        // Head
        
        if (rangeSelectionHeadView == nil) {

            rangeSelectionHeadView = UIView()
            rangeSelectionHeadView!.isHidden = true
            rangeSelectionHeadView!.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(rangeSelectionHeadView!)
            
            NSLayoutConstraint.activate([
                rangeSelectionHeadView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                rangeSelectionHeadView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                rangeSelectionHeadView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: startingX),
                rangeSelectionHeadView!.heightAnchor.constraint(equalToConstant: smallestSide * circleRatio)
            ])
        }
        
        rangeSelectionHeadView!.backgroundColor = .lightGray
        
        
        // Middle
        
        if (rangeSelectionMiddleView == nil) {
            
            rangeSelectionMiddleView = UIView()
            rangeSelectionMiddleView?.translatesAutoresizingMaskIntoConstraints = false
            
            rangeSelectionMiddleView!.isHidden = true
            
            addSubview(rangeSelectionMiddleView!)
            
            NSLayoutConstraint.activate([
                rangeSelectionMiddleView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                rangeSelectionMiddleView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                rangeSelectionMiddleView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                rangeSelectionMiddleView!.heightAnchor.constraint(equalToConstant: smallestSide * circleRatio)
            ])
        }
        
        rangeSelectionMiddleView!.backgroundColor = .lightGray
        
        
        // Tail
        
        if (rangeSelectionTailView == nil) {

            rangeSelectionTailView = UIView()
            
            rangeSelectionTailView?.translatesAutoresizingMaskIntoConstraints = false
            rangeSelectionTailView!.isHidden = true
            
            addSubview(rangeSelectionTailView!)
            
            NSLayoutConstraint.activate([
                rangeSelectionTailView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                rangeSelectionTailView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -startingX),
                rangeSelectionTailView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                rangeSelectionTailView!.heightAnchor.constraint(equalToConstant: smallestSide * circleRatio)
            ])
        }
        
        rangeSelectionTailView!.backgroundColor = .lightGray
    }
    
    
    func configureTextLabel() {
        
        if (textLabel == nil) {
            
            textLabel = UILabel(frame: CGRect(x: 0,
                                              y: 0,
                                              width: bounds.width,
                                              height: bounds.height)
            )
            
            textLabel!.textAlignment = NSTextAlignment.center
            
            addSubview(textLabel!)
        }
        
        textLabel?.font = style.dayTextFont // TODO: Maybe check if this avoiding resetting this is necessary (optimization)
//        textLabel?.textColor = style.dayTextColor
        textLabel?.text = String(day)
    }
    
    func configureTodayIndicatorView() {
        
        let smallestSide = min(frame.width, frame.height)
        let width = smallestSide * circleRatio
        let height = smallestSide * circleRatio
        let cornerRadius = smallestSide * circleRatio / 2
        
        if (todayIndicatorView == nil) {
            
            todayIndicatorView = UIView()
            todayIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
            todayIndicatorView?.backgroundColor = style.todayIndicatorBackgroundColor
            todayIndicatorView?.layer.cornerRadius = cornerRadius

            addSubview(todayIndicatorView!)
            
            NSLayoutConstraint.activate([
                todayIndicatorView!.centerXAnchor.constraint(equalTo: centerXAnchor),
                todayIndicatorView!.centerYAnchor.constraint(equalTo: centerYAnchor),
                todayIndicatorView!.widthAnchor.constraint(equalToConstant: width),
                todayIndicatorView!.heightAnchor.constraint(equalToConstant: height)
            ])
        }
        
        todayIndicatorView!.isHidden = !isToday
        
        // TODO: Not ready
//        todayIndicatorView!.layer.borderWidth = style.todayIndicatorBorderWidth
//        todayIndicatorView!.layer.borderColor = style.todayIndicatorBorderColor.cgColor
    }
    
    
    // MARK: - Appearance
    
    public func configure(style: ALKCalendarAppearance, day: Int, isToday: Bool, isWeekend: Bool, belongsToCurrentMonth: Bool) {
        
        // Update the local variables
        self.style = style
        self.day = day
        self.isToday = isToday
        self.isWeekend = isWeekend
        self.belongsToCurrentMonth = belongsToCurrentMonth
        
        // -- Style Configuration
        // *If the current style is different, the views may need to be reconstructed or modified
        
        // Single Selection Appearance
        configureSingleSelectionView()
        
        // Range Selection Appearance
        configureRangeSelectionViews()
        
        // Today Indicator
        configureTodayIndicatorView()
        
        // Text Label Appearance (except color)
        configureTextLabel()
                
        // Text Label Color
        updateTextColor()
    }
    
    private func updateTextColor() {
        
        // TODO: Update this when the priority of the colors has been decided
        switch selectionState {
            
        case .single:
            if isToday {
                self.textLabel?.textColor = style.todayIndicatorTextColor
            } else {
                self.textLabel?.textColor = style.selectedCellTextColor
            }
            
        case .start:
            if isToday {
                self.textLabel?.textColor = style.todayIndicatorTextColor
            } else {
                self.textLabel?.textColor = style.selectedCellTextColor
            }
        case .middle:
            if isToday {
                self.textLabel?.textColor = style.todayIndicatorTextColor
            } else {
                self.textLabel?.textColor = style.selectedCellTextColor
            }
        case .end:
            if isToday {
                self.textLabel?.textColor = style.todayIndicatorTextColor
            } else {
                self.textLabel?.textColor = style.selectedCellTextColor
            }
            
        case .none:
            if isToday {
                self.textLabel?.textColor = style.todayIndicatorTextColor
            } else if !belongsToCurrentMonth {
                self.textLabel?.textColor = style.belongsToDifferentMonthTextColor
            } else if isWeekend {
                self.textLabel?.textColor = style.weekendTextColor
            } else {
                self.textLabel?.textColor = style.dayTextColor
            }
            break
        }
    }
}

// MARK: - ALKSelectionManager Interface
extension ALKDayCell {
    
    public func setSelectionState(_ state : ALKSelectionManager.ALKSelectionState?) {
        
        // Convert it to this cell's internal state
        self.selectionState = convertManagerSelectionAppearance(state)
        
        // Change the visible selection view
        updateSelectionViewsVisibility()
        
        updateTextColor()
    }
    
    private func updateSelectionViewsVisibility() {
        
        // Set all the selection views to hidden
        singleSelectionView?.isHidden = true
        rangeSelectionHeadView?.isHidden = true
        rangeSelectionMiddleView?.isHidden = true
        rangeSelectionTailView?.isHidden = true
        
        // Toggle the visibility of the appropriate view depending on the current selection state
        switch selectionState {
            
        case .single:
            singleSelectionView?.isHidden = false
            
        case .start:
            rangeSelectionHeadView?.isHidden = false
        case .middle:
            rangeSelectionMiddleView?.isHidden = false
        case .end:
            rangeSelectionTailView?.isHidden = false
            
        case .none:
            break
            
        }
    }
    
    // Convenience function to convert ALKSelectionManager.ALKSelectionState to ALKDayCell.ALKDayCellSelectionState
    private func convertManagerSelectionAppearance(_ appearance : ALKSelectionManager.ALKSelectionState?) -> ALKDayCell.ALKDayCellSelectionState {
        
        guard let appearance = appearance else {
            return .none
        }
        
        switch appearance {
        case .notSelected:
            return .none
        case .singleSelection:
            return .single
        case .rangeStartSelection:
            return .start
        case .rangeMiddleSelection:
            return .middle
        case .rangeEndSelection:
            return .end
        }
    }
}
