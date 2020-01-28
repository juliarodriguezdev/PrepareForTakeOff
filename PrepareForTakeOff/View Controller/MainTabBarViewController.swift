//
//  MainTabBarViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.customGray
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = .black
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 7)
        
    }
}
