//
//  LaunchPageViewController.swift
//  Swish
//
//  Created by Clay Mills on 4/25/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class LaunchPageViewController: UIPageViewController {
    
    weak var launchDelegate: LaunchPageViewControllerDelegate?
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.swishLaunchViewController(onboard: "Welcome"),
                self.swishLaunchViewController(onboard: "Swiping"),
                self.swishLaunchViewController(onboard: "MoreInfo")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
    // load up first view controller
        if let firstViewController = orderedViewControllers.first {
            scrollToViewController(firstViewController)
        }
        
        launchDelegate?.launchPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    fileprivate func swishLaunchViewController(onboard: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "\(onboard)ViewController")
    }
    
    fileprivate func scrollToViewController(_ viewController: UIViewController, direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: {(finished) -> Void in
            self.notifyLaunchDelegateOfNewIndex()
        })
    }
    
    fileprivate func notifyLaunchDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            launchDelegate?.launchPageViewController(self, didUpdatePageIndex: index)
        }
    }
}
extension LaunchPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
                return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
                return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
}

extension LaunchPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        notifyLaunchDelegateOfNewIndex()
    }
}

protocol LaunchPageViewControllerDelegate: class {

    func launchPageViewController(_ LaunchPageViewController: LaunchPageViewController, didUpdatePageCount count: Int)

    func launchPageViewController(_ launchPageViewController: LaunchPageViewController, didUpdatePageIndex index: Int)
}
