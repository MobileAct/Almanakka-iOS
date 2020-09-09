//
//  ALKMonthView.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/13.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public protocol ALKMonthViewDelegate: class {
    
    /// Return 'false" to disable the tapped cell from being selected.
    /// - Parameters:
    ///   - monthView: The month view that triggered the event.
    ///   - date: The date that represents the tapped cell.
    func monthView(_ monthView: ALKMonthView, shouldSelectDate date: Day) -> Bool
    
    /// Called when a cell is selected.
    /// - Parameters:
    ///   - monthView: The month view that triggered the event.
    ///   - date: The date that represents the selected cell.
    func monthView(_ monthView: ALKMonthView, didSelectDate date: Day)
    
}

// Default implementations of the protocol methods (to make them optional)
public extension ALKMonthViewDelegate {
    func monthView(_ monthView: ALKMonthView, shouldSelectDate date: Day) -> Bool { true }
    func monthView(_ monthView: ALKMonthView, didSelectDate date: Day) {}
}

public class ALKMonthView: UIView {
    
    // MARK: - Calendar Info
    
    public var month : Month! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Calendar Properties
    public var style: ALKCalendarAppearance = ALKCalendarAppearance.Default {
        didSet {
            if style.shouldShowWeekdays {
                flowLayout.setHeaderHeight(height: style.weekdaysViewHeight)
            } else {
                flowLayout.setHeaderHeight(height: 0)
            }
            
            collectionView.reloadData()
        }
    }
    
    public let cellReuseIdentifier = "ALKDayCell"
    
    public weak var delegate: ALKMonthViewDelegate?
    
    internal var selectionManager: ALKSelectionManager? {
        didSet {
            // When a selection manager is attached to this view, all the cells are updated to match the currently selected dates
//            reloadCalendarItems()
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }
    
    // TODO: Move to a diff place
    public func reloadCalendar() {
        collectionView.reloadData()
    }
    
    private func updateDaysSelectedAppearance() {
        
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        
        visibleIndexPaths.forEach { (indexPath) in
            
            guard let dayCell = collectionView.cellForItem(at: indexPath) as? ALKDayCell else {
                return
            }
            
            let day = month.days[indexPath.item]
            
            dayCell.setSelectionState(selectionManager?.appearanceForDay(day))
        }
    }
    
    
    private let headerIdentifier: String = "ALKWeekDaysViewHeader"
    private var collectionView: UICollectionView!
    private var flowLayout: ALKCollectionViewFlowLayout!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Flow Layout Configuration
        self.flowLayout = ALKCollectionViewFlowLayout()
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.sectionInset = UIEdgeInsets.zero
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.itemSize = calculateDayCellSizeForViewSize(self.frame.size)

        // Collection View Configuration
        self.collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size),
                                               collectionViewLayout: self.flowLayout)
        self.collectionView.isScrollEnabled = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.allowsMultipleSelection = false // TODO: Shouldn't this be true?
        self.collectionView.register(ALKDayCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        let bundle = BundleLoader.AlmanakkaBundle()
        self.collectionView.register(UINib(nibName: "WeekDaysHeaderView",bundle: bundle),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: headerIdentifier)
        
        self.addSubview(self.collectionView)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        // TODO: Check if this should be 'bounds'
        self.collectionView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        self.flowLayout.itemSize = calculateDayCellSizeForViewSize(self.bounds.size)
    }
    
    private func calculateDayCellSizeForViewSize(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width / 7.0, height: (size.height - style.weekdaysViewHeight) / 6.0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ALKMonthView: UICollectionViewDelegateFlowLayout {
    
    // MARK: Selection
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let day = month.days[indexPath.item]

        return delegate?.monthView(self, shouldSelectDate: day) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = month.days[indexPath.item]

        // TEMP -- alternative method
        selectionManager?.select(day)
        updateDaysSelectedAppearance()
        // alternative method - TEMP END
        
        delegate?.monthView(self, didSelectDate: day)

    }
    

    // TODO: maybe this isn't needed after all (if selection manager will handle everything
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
//        let day = month.days[indexPath.item]


    }
    
    // MARK: Layout

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! WeekDaysHeaderView
            headerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: style.weekdaysViewHeight)

            return headerView
        }

        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerSize: CGSize
        if style.shouldShowWeekdays {
            headerSize = CGSize(width: collectionView.bounds.width, height: style.weekdaysViewHeight)
        } else {
            headerSize = .zero
        }
        return headerSize
    }
}

// MARK: - UICollectionViewDataSource
extension ALKMonthView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (month != nil) ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? ALKDayCell else {
            fatalError()
        }
        
        // Get the day info that should be shown on this cell
        let day = month.days[indexPath.item]
                
        // Configure the cell
        cell.configure(style: style,
                       day: day.value,
                       isToday: day.isToday,
                       isWeekend: day.isWeekend,
                       belongsToCurrentMonth: month.contains(day: day))
        
        cell.setSelectionState(selectionManager?.appearanceForDay(day))

        return cell
    }
    
    
}


