//
//  CustomTabBarController.swift
//  Nexus Pay
//
//  Created by TGPL-MACMINI-66 on 06/05/24.
//

//import UIKit
//
//class CustomTabBarController: UITabBarController {
//
//    var slidingLine: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Remove default tab bar top line
//        self.tabBar.shadowImage = UIImage()
//        self.tabBar.backgroundImage = UIImage()
//
//        // Add sliding line
//        let tabBarHeight = tabBar.frame.size.height
//        let tabCount = CGFloat(viewControllers?.count ?? 0)
//        let slidingLineWidth = tabBar.frame.width / tabCount
//        let initialX = tabBar.frame.origin.x
//        slidingLine = UIView(frame: CGRect(x: initialX, y: 0, width: slidingLineWidth, height: 2))
//        slidingLine.backgroundColor = UIColor.appColor // Change color as needed
//        tabBar.addSubview(slidingLine)
//        
//    }
//
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let selectedIndex = tabBar.items?.firstIndex(of: item) ?? 0
//        let tabBarWidth = tabBar.frame.width
//        let tabCount = CGFloat(tabBar.items?.count ?? 0)
//        let slidingLineWidth = tabBarWidth / tabCount
//        let newX = tabBar.frame.origin.x + (slidingLineWidth * CGFloat(selectedIndex))
//        UIView.animate(withDuration: 0.3) {
//            self.slidingLine.frame.origin.x = newX
//        }
//    }
//}

import UIKit

class CustomTabBarController: UITabBarController {

    var slidingLine: UIView!
    var topBorder: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove default tab bar top line
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()

        // Add sliding line
        let tabBarHeight = tabBar.frame.size.height
        let tabCount = CGFloat(viewControllers?.count ?? 0)
        let slidingLineWidth = tabBar.frame.width / tabCount
        let initialX = tabBar.frame.origin.x
        slidingLine = UIView(frame: CGRect(x: initialX, y: 0, width: slidingLineWidth, height: 2)) // Changed height to 4
        slidingLine.backgroundColor = UIColor.appColor // Change color as needed
        tabBar.addSubview(slidingLine)

        // Add top border
        topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.3)) // Changed height to 1
        topBorder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8) // Reduced alpha
        tabBar.addSubview(topBorder)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedIndex = tabBar.items?.firstIndex(of: item) ?? 0
        let tabBarWidth = tabBar.frame.width
        let tabCount = CGFloat(tabBar.items?.count ?? 0)
        let slidingLineWidth = tabBarWidth / tabCount
        let newX = tabBar.frame.origin.x + (slidingLineWidth * CGFloat(selectedIndex))
        UIView.animate(withDuration: 0.3) {
            self.slidingLine.frame.origin.x = newX
        }
    }
}
