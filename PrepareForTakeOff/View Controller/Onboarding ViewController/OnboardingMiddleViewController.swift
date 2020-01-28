//
//  OnboardingMiddleViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class OnboardingMiddleViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var paperPlaneImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        welcomeLabel.text = "We can't wait to \nsee where you will go!"
        paperPlaneImage.alpha = 1
        animatePaperPlane()
        
    }
    func setupUI() {
        self.view.backgroundColor = UIColor.travelBackground
    }
    
    func animatePaperPlane() {
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            self.paperPlaneImage.alpha = 0
        }) { (success) in
            if success {
                // show next storyboard
                self.showOnboardingEndVC()
            }
        }
    }
    func showOnboardingEndVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let onboardingEndViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingEndViewController") as? OnboardingEndViewController else { return }
         self.navigationController?.pushViewController(onboardingEndViewController, animated: true)
    }

    

}
