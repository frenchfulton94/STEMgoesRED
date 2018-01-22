//
//  AppPageViewControllerDataSource.swift
//  STEM goes RED
//
//  Created by Michael Fulton Jr. on 12/20/17.
//  Copyright © 2017 Michael Fulton Jr. All rights reserved.
//

import UIKit

extension AppPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = mainControllers.index(of: viewController) else {
            return nil
        }
        print("VCINDEX \(vcIndex)")
        let prevIndex = vcIndex - 1
        
        guard prevIndex >= 0 else {
            return nil
        }
        
        guard mainControllers.count > prevIndex else {
            return nil
        }
        return mainControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = mainControllers.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = vcIndex + 1
        
        guard mainControllers.count != nextIndex else {
            return nil
        }
        
        guard mainControllers.count > nextIndex else {
            return nil
        }
        
        return mainControllers[nextIndex]
        
 }

}
