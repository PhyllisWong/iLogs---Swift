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
    var dismissableViewControllers = Set<UIViewController>()
    
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
        }
    }
    
    var diaryController = DiaryController()
    
    var timersController = TimersController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

extension NSNotification.Name {
    static var StatusBarDidTapAndHold = NSNotification.Name(rawValue: "kNotificationStatusBarDidTapAndHold")
}

