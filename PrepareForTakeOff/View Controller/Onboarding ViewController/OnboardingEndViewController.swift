//
//  OnboardingEndViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class OnboardingEndViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var paperPlaneImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
                self.createFirstTripViewController()
            }
        }
    }
    func createFirstTripViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let createTripViewController = storyboard.instantiateViewController(withIdentifier: "CreateTripViewController") as? CreateTripViewController else { return }
        self.navigationController?.pushViewController(createTripViewController, animated: true)
    }
    
    
}
