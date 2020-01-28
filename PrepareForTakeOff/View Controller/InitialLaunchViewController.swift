//
//  InitialLaunchViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/30/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class InitialLaunchViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.travelBackground
        
        if defaults.bool(forKey: "First Launch") == true {
            print("Second+")
            // to main list of trips
            navigateToMainTabBar()
           // defaults.set(true, forKey: "First Launch")
        } else {
            print("First")
            // to first onboarding
            showOnboardingBeginVC()
            defaults.set(true, forKey: "First Launch")
        }
    }
    
    func navigateToMainTabBar() {
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        guard let mainTabBarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else { return }
        self.navigationController?.pushViewController(mainTabBarViewController, animated: true)
    }
    
    func showOnboardingBeginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let onboardingBeginViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingBeginViewController") as? OnboardingBeginViewController else { return }
        self.navigationController?.pushViewController(onboardingBeginViewController, animated: true)
    }
}
