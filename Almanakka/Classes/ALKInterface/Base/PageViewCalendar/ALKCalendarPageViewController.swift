//
//  ALKCalendarPageViewController.swift
//  ALKInterface
//
//  Created by Oscar Peredo on 2020/05/12.
//  Copyright © 2020 Mobile Act, All rights reserved.
//

import UIKit

public protocol ALKCalendarPageViewControllerDelegate : class {

    // Output
    func pageViewScrolling(percent : CGFloat)
    func pageChanged()
}

// Default implementation (to make them optional)
public extension ALKCalendarPageViewControllerDelegate {
    func pageViewScrolling(percent : CGFloat) {}
    func pageChanged() {}
}

public class ALKCalendarPageViewController: UIPageViewController {
    
    // Delegates
    public weak var calendarDelegate : ALKCalendarPageViewControllerDelegate?
//    public weak var monthViewDelegate : ALKMonthViewDelegate?
    
    // State Variables
    public var displayedMonth : Month = Month(referenceDate: .today)
    public var isChangingPage : Bool = false
    
    // Appearance
    public var style: ALKCalendarAppearance = ALKCalendarAppearance.Default
    
    // MARK: Selection
    internal var selectionManager: ALKSelectionManager?

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegate for the underlying scroll view
        // (to monitor when the user scrolls left/right to change)
        for subView in view.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delegate = self
            }
        }
        
        dataSource = self
        delegate = self
    }
    
    
    // MARK: - Interface
    
    public func resetViewControllers() {
        
        // Reset the scroll offset cache
//        clearContentOffsetsCache()
        
        // Initial Values
        displayedMonth = Month(referenceDate: .today)
        
        // Load the initial view controllers
        if let currentVC = loadViewControllerFor(date: displayedMonth) {
            self.setViewControllers([currentVC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

            currentVC.didMove(toParent: self)
        }
    }
    
    
    // MARK:- Internal Methods
    
    
    // Creates the required view controller and loads it to memory.
    private func loadViewControllerFor(date : Month) -> ALKMonthViewController? {
        
//        let section = CouponsPresenter.CouponSection(section: index)
//
//        guard let couponsList = couponsDataSource?.couponsForSection(section), let sortOrder = couponsDataSource?.sortOrder else {
//            print("CouponsPageViewController -> loadViewControllerAt: Can't load view controller, none exists for index \(index).")
//            return nil
//        }
                        
        // Create a 'ALKMonthViewContainer'
        
        
        // Create a new instance of a month view controller
        let pageVC = ALKMonthViewController.instantiateFromStoryboard()
        
        // Set the appearance
        // TODO: It might be possible to get this from further up
        pageVC.style = style
        
        // Set the month the vc will represent
        pageVC.month = date
        
        // Attach the delegate to receive calls from the ALKMonthView
        pageVC.delegate = self // TODO: not implemented
        
        // Share the calendar selection manager with this ALKMonthView
        pageVC.selectionManager = selectionManager
        
        // Load the view controller in memory (for smooth paging)
        pageVC.loadViewIfNeeded()
        
        return pageVC
    }
}


// MARK: - UIPageViewControllerDelegate

extension ALKCalendarPageViewController : UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed) {
            return;
        }
        
        // The page view controller should only have one VC, (left and right ones are inside the 'children' array)
        if let currentVC = pageViewController.viewControllers?.last as? ALKMonthViewController, let pageDate = currentVC.month {
            
            // Update the state variables
            displayedMonth = pageDate
            isChangingPage = false
            
            calendarDelegate?.pageChanged()
        }
    }
}


// MARK: - UIPageViewControllerDataSource

extension ALKCalendarPageViewController : UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        print("viewController BEFORE")
        
        guard let currentVC = viewController as? ALKMonthViewController, let pageDate = currentVC.month else { return nil }
                
        // Calculate the month before the current one
        let targetDate = pageDate.advanced(by: -1)
        
        guard let targetVC = loadViewControllerFor(date: targetDate) else {
            return nil
        }
        
        return targetVC
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        print("viewController AFTER")

        guard let currentVC = viewController as? ALKMonthViewController, let pageDate = currentVC.month else { return nil }
        
        // Calculate the month after the current one
        let targetDate = pageDate.advanced(by: 1)

        guard let targetVC = loadViewControllerFor(date: targetDate) else {
            return nil
        }
        
        return targetVC
    }
}


// MARK: - UIScrollViewDelegate

extension ALKCalendarPageViewController : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Get the horizontal scrolled percentage of the page controller
        let scrolledPercent = (scrollView.contentOffset.x - view.frame.size.width) / view.frame.size.width
        // Foward it to the delegate
        calendarDelegate?.pageViewScrolling(percent: scrolledPercent)
    }
}

// MARK: - ALKMonthViewDelegate

extension ALKCalendarPageViewController : ALKMonthViewDelegate {
    
    // TODO: Not implemented
    
    
    public func monthView(_ monthView: ALKMonthView, didSelectDate date: Day) {
        // Something was selected in the current Page VC, the other VCs must be updated accordingly
        for vc in children {
            guard let calendarVC = vc as? ALKMonthViewController else {
                continue
            }
            
            // Skip the currently displayed View Controller
            if let viewControllers = viewControllers, viewControllers.contains(calendarVC) {
                continue
            }
            
            // Reload the view controllers that are not currently visible            
            calendarVC.monthView.reloadCalendar()
        }
        return
    }
    
}
