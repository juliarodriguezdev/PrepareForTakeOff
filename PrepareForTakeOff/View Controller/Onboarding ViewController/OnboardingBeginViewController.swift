//
//  OnboardingBeginViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class OnboardingBeginViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var paperplaneImage: UIImageView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // alpha is set to 1 of paper airplane
        setUPUI()
        paperplaneImage.alpha = 1
        toMiddleOnboardingVC()
    }
    func setUPUI() {
        self.view.backgroundColor = UIColor.travelBackground
    }
    //uiview animate, to bring alpha to 0 then ->
    func toMiddleOnboardingVC() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            self.paperplaneImage.alpha = 0
        }) { (success) in
            if success {
                // show next story board
                    self.showOnboardingMiddleVC()
                
            }
        }
    }
    
    // show next story board
    func showOnboardingMiddleVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let onboardingMiddleViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingMiddleViewController") as? OnboardingMiddleViewController else { return }
        self.navigationController?.pushViewController(onboardingMiddleViewController, animated: true)
    }
    
    func showMainTripListViewController() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let mainTripListViewController = storyboard.instantiateViewController(withIdentifier: "TripViewController") as? TripViewController else { return }
        self.navigationController?.pushViewController(mainTripListViewController, animated: true)
    }
}
