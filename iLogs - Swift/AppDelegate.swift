//
//  AppDelegate.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 9/23/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    class var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate! as! AppDelegate
    }

    var window: UIWindow?
    
    /**
     By interating visibleViewControllers, selectedViewControllers, and
     presentedViewControllers, topViewController(:) will return the current
     view controller that is visible in the UIWindow
     */
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    /**
     a set that contains view controllers that can be dismissed
     by a tap from the status bar
     */
    func register(viewControllerAsDismissable viewController: UIViewController) {
        dismissableViewControllers.insert(viewController)
    }
    ///stored view controllers
    private var dismissableViewControllers = Set<UIViewController>()
    
    /** flag showing if the last touch event was inside of the status bar */
    private var touchingInsideDismisser: Bool?
    
    /** timer to dismiss the controller view controller */
    private var statusBarDimisserTimer: UIKit.Timer?
    
    private func isTouchInStatusBar(point: CGPoint) -> Bool {
        return UIApplication.shared.statusBarFrame.contains(point)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //if begin tap is inside of the status bar, fire a timer
        if let touchLocation = event?.allTouches?.first?.location(in: window!) {
            if isTouchInStatusBar(point: touchLocation) {
                touchingInsideDismisser = true
                statusBarDimisserTimer = UIKit.Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(dismissController), userInfo: nil, repeats: false)
            } else {
                touchingInsideDismisser = nil
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        //Check if the touch location is still inside the status bar rect if
        //not, set bool to false
        if let touchLocation = event?.allTouches?.first?.location(in: window!) {
            if statusBarDimisserTimer != nil {
                if isTouchInStatusBar(point: touchLocation) == false {
                    touchingInsideDismisser = false
                    statusBarDimisserTimer!.invalidate()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //stop timer and set bool to nil
        touchingInsideDismisser = nil
        statusBarDimisserTimer?.invalidate()
    }
    
    @objc private func dismissController() {
        let currentViewController = AppDelegate.topViewController()!
        if touchingInsideDismisser! == true && dismissableViewControllers.contains(currentViewController) {
            NotificationCenter.default.post(name: NSNotification.Name.StatusBarDidTapAndHold, object: nil)
            currentViewController.presentingViewController!.dismiss(animated: true)
            dismissableViewControllers.remove(currentViewController)
        }
    }
    
    var diaryController = DiaryController()
    
    var timersController = TimersController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

extension NSNotification.Name {
    static var StatusBarDidTapAndHold = NSNotification.Name(rawValue: "kNotificationStatusBarDidTapAndHold")
}

