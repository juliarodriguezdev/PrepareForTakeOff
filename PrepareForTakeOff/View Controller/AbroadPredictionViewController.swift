//
//  AbroadPredictionViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class AbroadPredictionViewController: UIViewController {
    
    @IBOutlet weak var predictionLabel: UILabel!
    
    @IBOutlet weak var noButton: GrayButton!
    
    @IBOutlet weak var yesButton: GrayButton!
    
    //landing pad, maybe
    var isUSA: Bool?
    var selectedCity: String?
    var predictedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let predictedCountry = predictedCountry,
            let selectedCity = selectedCity {
            predictionLabel.text = "By any chance is \(selectedCity) \nlocated in \(predictedCountry)?"
        }
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        showPlaceholderViewController()
        
    }
    
    func showPlaceholderViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let placeholderViewController = storyboard.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController else { return }
        // pass isUSA Bool
        placeholderViewController.isUSA = false
        // pass city Name
        placeholderViewController.selectedCity = selectedCity
        self.navigationController?.pushViewController(placeholderViewController, animated: true)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // only for abroad, pass city and country iso codes
        if segue.identifier == "toMainTripVC" {
            let destinationVC = segue.destination as? CreateTripViewController
            destinationVC?.city = selectedCity ?? ""
            // send country as iso country code
            destinationVC?.countryName = predictedCountry ?? ""
            destinationVC?.isUSA = false
        }
        // Pass the selected object to the new view controller.
    }
    

}
