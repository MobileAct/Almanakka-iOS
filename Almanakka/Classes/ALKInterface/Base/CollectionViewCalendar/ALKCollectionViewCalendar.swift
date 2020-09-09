//
//  ALKCollectionViewCalendar.swift
//  Almanakka
//
//  Created by Rogozhkin Vladimir on 2020/04/20.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

// MARK:- ALKCollectionViewCalendarDelegate
public protocol ALKCollectionViewCalendarDelegate {
    
    func almanakka(_ almanakka: ALKCollectionViewCalendar, didScrollTo date: (year: Year, month: Month))

    func calendar(_ calendar: ALKCollectionViewCalendar, shouldSelectDate date: Day) -> Bool
    
    func calendar(_ calendar: ALKCollectionViewCalendar, didSelectDateRanges dates: [Day])
    
}

// Default implementations of the protocol methods (to make them optional)
public extension ALKCollectionViewCalendarDelegate {
    func almanakka(_ almanakka: ALKCollectionViewCalendar, didScrollTo date: (year: Year, month: Month)) {}
    func calendar(_ calendar: ALKCollectionViewCalendar, shouldSelectDate date: Day) -> Bool { true }
    func calendar(_ calendar: ALKCollectionViewCalendar, didSelectDateRanges dates: [Day]) {}
}

// MARK:- ALKCollectionViewCalendar
public class ALKCollectionViewCalendar: UIView {
    
    //MARK: Calendar Properties
    public var style: ALKCalendarAppearance = ALKCalendarAppearance.Default
    public let cellReuseIdentifier = "ALKDayCell"
    public let numberOfMonthsInYear: Int = 12
    
    public var delegate: ALKCollectionViewCalendarDelegate?
    
    public internal(set) var selectedIndexPath = [IndexPath]()
    public internal(set) var selectedDate = [Day]()
    
    public var isDeselectEnable = false
    public var isMultipleSelectionEnable = false 
    public var isAdjacentCellSelectDisabled = true
    
    //MARK: Infinity Scroll Properties
    private let indexForForwardShift: CGFloat = 23
    private let indexForBackwardShift: CGFloat = 12
    
    private var yearContentWidth: CGFloat = 0.0
    private var yearContentHeight: CGFloat = 0.0
    private var monthContentWidth: CGFloat { return yearContentWidth / CGFloat(numberOfMonthsInYear)}
    private var monthContentHeight: CGFloat { return yearContentHeight / CGFloat(numberOfMonthsInYear)}
    
    private var isFirstLoad = false
    private let itemSpacing: CGFloat = 30
    private let headerIdentifier = "header"
    
    private var collectionView: UICollectionView!
    
    private var flowLayout: UICollectionViewFlowLayout {
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    public var isPagingEnabled: Bool = true {
        didSet {
            collectionView.isPagingEnabled = isPagingEnabled
        }
    }
    
    // MARK: Selection
    internal var selectionManager: ALKSelectionManager? 
    public var selectionMode: ALKSelectionManager.ALKSelectionMode = .off {
        didSet {
            selectionManager = ALKSelectionManager(selectionMode: selectionMode)
            collectionView.reloadData()
        }
    }

    // MARK: Sticky Header
    public var isStickyHeaderEnabled: Bool = true {
        didSet {
            flowLayout.sectionHeadersPinToVisibleBounds = isStickyHeaderEnabled
        }
    }
    
    // MARK: Direction
    public var direction: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = direction
            self.setLineSpacingsForFlowLayout()
            self.collectionView.reloadData()
        }
    }
    
    private func setLineSpacingsForFlowLayout() {
        switch flowLayout.scrollDirection {
        case .horizontal:
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        case .vertical:
            flowLayout.minimumLineSpacing = itemSpacing
            flowLayout.minimumInteritemSpacing = itemSpacing
        @unknown default:
            fatalError()
        }
    }
    
    private let dataManager = InfiniteCalendarDataManager(referenceDate: .today)
    private var pageCalculator: PageCalculator!
    private var scrollExecutor: CalendarScrollExecutor!
    
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
        
        setupForCollectionView()
        
        self.pageCalculator = .init(collectionView: self.collectionView, direction: self.direction)
        self.scrollExecutor = .init(collectionView: self.collectionView, dataManager: self.dataManager)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()

        self.collectionView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        flowLayout.itemSize = self.cellSize(in: self.bounds)
        setInitalScrollPostion()
    }

    func scrollToIndex(section: Int) {
        
        guard let currentDisplayedMonth = yearAndMonthFromScrollViewPosition()?.month else {
            print("ALKCollectionViewCalendar: Couldn't obtain month from current scroll position")
            return
        }
        
        let zeroBasedCurrentDisplayedMonthIndex = currentDisplayedMonth.value - 1
        
        let differenceInIndex = section - zeroBasedCurrentDisplayedMonthIndex
        let newSectionIndex = pageCalculator.page() + differenceInIndex

        switch direction {
        case .vertical:
            setScrollPositionForVerticalCalendar(displayIndex: newSectionIndex)
        case .horizontal:
            setPositionForHorizontalCalendar(displayIndex: newSectionIndex)
        default:
            fatalError()
        }
    }
    
    func changeDisplayYear(year: Year) {
        dataManager.displayYearChanged(to: year)
        collectionView.reloadData()
    }
    
    private func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {
        let month = dataManager.months[indexPath.section]
        
        return month.days[indexPath.row].referenceDate
    }
}

// MARK:- Settings for collection view
private extension ALKCollectionViewCalendar {
    
    func setupForCollectionView() {
        self.collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: self.collectionViewFlowLayout()
        )

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false

        self.collectionView.isPagingEnabled = isPagingEnabled
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.allowsMultipleSelection = false
        
        self.collectionView.register(ALKCollectionMonthCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        let bundle = BundleLoader.AlmanakkaBundle()
        self.collectionView.register(
            UINib(nibName: "ALKCollectionViewHeader",bundle: bundle),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier
        )
        
        self.addSubview(self.collectionView)
    }
    
    func collectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.cellSize(in: self.bounds)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = self.direction
        layout.sectionHeadersPinToVisibleBounds = false
        
        return layout
    }

}

// MARK:- Settings for initial scroll position
private extension ALKCollectionViewCalendar {
    
    func setInitalScrollPostion() {
        
        let currentYearIndex = Int(numberOfMonthsInYear) * dataManager.rangeOfYearFromCurrentIndex
        let zeroBasedCurrentMonth = Month(referenceDate: .today).value - 1
        let currentDisplayMonthIndex = currentYearIndex + zeroBasedCurrentMonth
        
        collectionView.reloadSections(IndexSet(integer: currentDisplayMonthIndex))
        
        
        switch self.direction {
        case .horizontal:
            setPositionForHorizontalCalendar(displayIndex: currentDisplayMonthIndex)
            
        case .vertical:
            setScrollPositionForVerticalCalendar(displayIndex: currentDisplayMonthIndex)
            
        default:
            fatalError()
        }
    }
    
    func setPositionForHorizontalCalendar(displayIndex: Int) {
        collectionView.scrollToItem(
            at: IndexPath(item: 0, section: displayIndex),
            at: .centeredHorizontally,
            animated: false
        )
    }
    
    func setScrollPositionForVerticalCalendar(displayIndex: Int) {
        let indexPath = IndexPath(item: 0, section: displayIndex)
        let headerAttributes = self.collectionView.layoutAttributesForSupplementaryElement(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        let cellAttributes = self.collectionView.layoutAttributesForItem(at: indexPath)
        let cellYOrigin = cellAttributes?.frame.origin.y ?? 0.0
        let headerHeight = headerAttributes?.frame.size.height ?? 0.0
        
        let scrollingPosition = CGPoint(x: 0, y: cellYOrigin - headerHeight)
        collectionView.setContentOffset(scrollingPosition, animated: false)
    }
    
}

// MARK:- Settings for cell sizes
private extension ALKCollectionViewCalendar {
    
    private func cellSize(in bounds: CGRect) -> CGSize {
        guard self.collectionView != nil else {
            return CGSize(width: self.bounds.width, height: self.bounds.width)
        }
        
        switch direction {
        case .horizontal:
            return cellSizeForHorizontalCalendar(in: bounds)
        case .vertical:
            return cellSizeForVerticalCalendar(in: bounds)
        @unknown default:
            fatalError()
        }
    }
    
    private func cellSizeForVerticalCalendar(in bounds: CGRect) -> CGSize {
        let width = collectionView.bounds.width
        let height = (collectionView.bounds.height / 2) - itemSpacing
        return CGSize(width: width, height: height)
    }
    
    private func cellSizeForHorizontalCalendar(in bounds: CGRect) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension ALKCollectionViewCalendar: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if direction == .vertical {
            return UIEdgeInsets(top: 0, left: 0, bottom: itemSpacing, right: 0)
        } else {
            return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerSize: CGSize
        if direction == . vertical {
            headerSize = CGSize(width: collectionView.bounds.width, height: 50)
        } else {
            headerSize = .zero
        }
        return headerSize
    }
}

// MARK:- UIScrollViewDelegate
extension ALKCollectionViewCalendar {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch self.direction  {
        case .horizontal:
            scrollViewDidScrollInHorizontal(scrollView)
        case .vertical:
            scrollViewDidScrollInVertical(scrollView)
        @unknown default:
            fatalError("Unknown Direction")
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateAndNotifyScrolling()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateAndNotifyScrolling()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateAndNotifyScrolling()
    }
    
    private func updateAndNotifyScrolling() {
        guard let scrolledYearAndMonth = self.yearAndMonthFromScrollViewPosition() else {
            print("Date from Scroll View Position failed.")
            return
        }

        self.delegate?.almanakka(self, didScrollTo: scrolledYearAndMonth)
    }
    
    @discardableResult
    private func yearAndMonthFromScrollViewPosition() -> (year: Year, month: Month)? {
        let currentPage = pageCalculator.page()
        
        let scrolledMonth = dataManager.months[currentPage]
        let scrolledYear = Year(referenceDate: scrolledMonth.referenceDate)
        
        return (scrolledYear, scrolledMonth)
    }
}

// MARK:- Behavior of scrollViewDidScroll for Horizontal Scrolling
private extension ALKCollectionViewCalendar {
    
    func scrollViewDidScrollInHorizontal(_ scrollView: UIScrollView) {
        initializeYearContentWidthIfNeeded(scrollView)
        scrollHorizontally(scrollView)
    }
    
    func initializeYearContentWidthIfNeeded(_ scrollView: UIScrollView) {
        if yearContentWidth == 0.0 {
            yearContentWidth = floor(scrollView.contentSize.width / CGFloat(dataManager.totalNumberOfYears))
        }
    }
    
    func scrollHorizontally(_ scrollView: UIScrollView) {
        if isHorizontalScrollDirectionForward(scrollView) {
            scrollToPreviousYearHorizontally(scrollView)
        } else if isHorizontalScrollDirectionBackward(scrollView) {
            scrollToNextYearHorizontally(scrollView)
        }
    }
    
    func isHorizontalScrollDirectionForward(_ scrollView: UIScrollView) -> Bool {
        let offsetForTheForwardShift = yearContentWidth * CGFloat(dataManager.totalNumberOfYears - 1)
        return scrollView.contentOffset.x > offsetForTheForwardShift
    }
    
    func scrollToPreviousYearHorizontally(_ scrollView: UIScrollView) {
        scrollExecutor.scrollToPreviousYear(scrollDirection: .horizontal, newOffset: monthContentWidth * indexForBackwardShift)
        updateAndNotifyScrolling()
    }
    
    func isHorizontalScrollDirectionBackward(_ scrollView: UIScrollView) -> Bool {
        let offsetForTheBackwardShift = yearContentWidth - monthContentWidth
        return scrollView.contentOffset.x <= offsetForTheBackwardShift
    }
    
    func scrollToNextYearHorizontally(_ scrollView: UIScrollView) {
        scrollExecutor.scrollToNextYear(scrollDirection: .horizontal, newOffset: monthContentWidth * indexForForwardShift)
        updateAndNotifyScrolling()
    }
}

// MARK:- Behavior of scrollViewDidScroll for Vertical Scrolling
private extension ALKCollectionViewCalendar {
    
    func scrollViewDidScrollInVertical(_ scrollView: UIScrollView) {
        initializeYearContentHeightIfNeeded(scrollView)
        scrollVertically(scrollView)
    }
    
    func initializeYearContentHeightIfNeeded(_ scrollView: UIScrollView) {
        if yearContentHeight == 0.0 {
            yearContentHeight = floor(scrollView.contentSize.height / CGFloat(dataManager.totalNumberOfYears))
        }
    }
    
    func scrollVertically(_ scrollView: UIScrollView) {
        if isVerticalScrollDirectionBackward(scrollView) {
            scrollToPreviousYearVertically(scrollView)
        } else if isVerticalScrollDirectionForward(scrollView) {
            scrolledToNextYearVertically(scrollView)
        }
    }
    
    func isVerticalScrollDirectionBackward(_ scrollView: UIScrollView) -> Bool {
        let offsetForBackwardShift = yearContentHeight * CGFloat(dataManager.totalNumberOfYears - 1)
        return scrollView.contentOffset.y > offsetForBackwardShift
    }
    
    func scrollToPreviousYearVertically(_ scrollView: UIScrollView) {
        scrollExecutor.scrollToPreviousYear(scrollDirection: .vertical, newOffset: monthContentHeight * indexForBackwardShift)
        updateAndNotifyScrolling()
    }
    
    func isVerticalScrollDirectionForward(_ scrollView: UIScrollView) -> Bool {
        let offsetForForwardShift = yearContentHeight - monthContentHeight
        return scrollView.contentOffset.y <= offsetForForwardShift
    }
    
    func scrolledToNextYearVertically(_ scrollView: UIScrollView) {
        scrollExecutor.scrollToNextYear(scrollDirection: .vertical, newOffset: monthContentHeight * indexForForwardShift)
        updateAndNotifyScrolling()
    }
}

// MARK: - UICollectionViewDataSource
extension ALKCollectionViewCalendar: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataManager.months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? ALKCollectionMonthCell else {
            fatalError()
        }
        
        let month = dataManager.months[indexPath.section]
        cell.month = month
        cell.style = style
        cell.delegate = self
        cell.selectionManager = selectionManager
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ALKCollectionViewHeader
            
            let currentMonth = dataManager.months[indexPath.section]
            headerView.bind(with: currentMonth.value, year: currentMonth.year.value)

            return headerView
        }

        return UICollectionReusableView()
    }
}

// MARK:- ALKMonthViewDelegate
extension ALKCollectionViewCalendar: ALKMonthViewDelegate {

    public func monthView(_ monthView: ALKMonthView, didSelectDate date: Day) {
        let indexToBeRefreshed = indexPathToBeRefreshed()
        collectionView.reloadItems(at: indexToBeRefreshed)
        
        delegate?.calendar(self, didSelectDateRanges: selectionManager?.selectedDates() ?? [])
    }
    
    private func indexPathToBeRefreshed() -> [IndexPath] {
        var visibleIndex = collectionView.indexPathsForVisibleItems
        
        if let firstIndex = visibleIndex.first {
            visibleIndex.append(IndexPath(item: 0, section: firstIndex.section - 1))
        }
        
        if let lastIndex = visibleIndex.last {
            visibleIndex.append(IndexPath(item: 0, section: lastIndex.section + 1))
        }
        
        return visibleIndex
    }
    
}
