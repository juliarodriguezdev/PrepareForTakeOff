//
//  CreateTripViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    // ***** transferred to cityVC ********
//    @IBOutlet weak var cityTableView: UITableView!
//    @IBOutlet weak var cityTextField: UITextField!
    
    // *** transferred to placeholderVC ***
   // @IBOutlet weak var placeHolderTableView: UITableView!
   // @IBOutlet weak var placeHolderTextField: UITextField!
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var placeholderButton: UIButton!
    @IBOutlet weak var nextButton: GrayButton!
    
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var countrySelection: UISegmentedControl!
    
    var isUSA: Bool = true
    var city: String = ""
    var state: String = ""
    var countryName: String = ""
    //var stateCode: String = ""
    let defaults = UserDefaults.standard
    
    //var isoCountryCode: String = ""
    //var isoDestinationCurrencyCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = true
        let nunitoSemiBoldFont = UIFont(name: FontNames.nunitoSemiBold, size: 23.0)
        countrySelection.setTitleTextAttributes([NSAttributedString.Key.font: nunitoSemiBoldFont!], for: .normal)
        
        countrySelection.setTitle("US", forSegmentAt: 0)
        countrySelection.setTitle("Abroad", forSegmentAt: 1)
        countrySelection.selectedSegmentIndex = 0
        
        cityButton.setTitle("City", for: .normal)
        placeholderButton.setTitle("State", for: .normal)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateIntroLabelText()
    
        if city.isEmpty {
            cityButton.setTitle("City", for: .normal)
            placeholderButton.isHidden = true
            nextButton.isHidden = true
        } else {
            cityButton.setTitle("City: \(city)", for: .normal)
            placeholderButton.isHidden = false
            nextButton.isHidden = false
        }
        
        if isUSA == true {
            countrySelection.selectedSegmentIndex = 0
            updateStateTitle()
            // verify for abroad
        } else {
            countrySelection.selectedSegmentIndex = 1
            updateCountryTitle()
        }
    }
    
    @IBAction func countrySelectionTapped(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            //inUSASelected()
            isUSA = true
            countrySelection.selectedSegmentIndex = 0
            updateStateTitle()
            updateIntroLabelText()
        case 1:
            //inAbroadSelected()
            isUSA = false
            countrySelection.selectedSegmentIndex = 1
            updateCountryTitle()
            updateIntroLabelText()
        default:
            print("nothing selected")
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        
        if defaults.bool(forKey: "First Trip Creation") == true {
            print("Second Trip Attempt")
            self.navigationController?.popViewController(animated: true)
            
        } else {
            print("First Trip Attempt")
            navigateToMainTabBar()
            defaults.set(true, forKey: "First Trip Creation")
        }
    }
    
    func updateCountryTitle() {
        if countryName.isEmpty {
            placeholderButton.setTitle("Country", for: .normal)
        } else {
            placeholderButton.setTitle("Country: \(countryName)", for: .normal)
        }
    }
    func updateStateTitle() {
        if state.isEmpty {
            placeholderButton.setTitle("State", for: .normal)
        } else {
            placeholderButton.setTitle("State: \(state)", for: .normal)
        }
    }
    func updateIntroLabelText() {
        if !city.isEmpty {
            if isUSA == true {
                if !state.isEmpty {
                    introLabel.text = "Review your trip details \nto continue"
                } else {
                    introLabel.text = "Where are you going?"
                }
            } else {
                if !countryName.isEmpty {
                    introLabel.text = "Review your trip details \nto continue"
                } else {
                    introLabel.text = "Where are you going?"
                }
            }
        } else {
            introLabel.text = "Where are you going?"
        }
    }
  
  
    @IBAction func cityButtonTapped(_ sender: UIButton) {
        // send object to next viewcontroller
        showCityViewController()
        
    }
    
    @IBAction func placeholderButtonTapped(_ sender: UIButton) {
        showPlaceholderViewController()
    }
    
    // TODO: Leads to next VC for time duration of trip
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        // ***** transferred to cityVC *******
        if isUSA == true {
            if !city.isEmpty && !state.isEmpty {
               
            } else {
                presentUIHelperAlert(title: "Missing Info", message: "Invalid destination entry, please enter all fields.")
                return
            }
        // Abroad
        } else {
            if !city.isEmpty && !countryName.isEmpty {
             
            } else {
                presentUIHelperAlert(title: "Missing Info", message: "Invalid destination entry, please enter all fields.")
                return
            }
        }
        showCreateTripPart2ViewController()
        
    }
    
    // Helper Func for UI Alert
    func presentUIHelperAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
    func showCityViewController() {
        
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let cityViewController = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController else { return }
        // send isUSA Bool
        cityViewController.isUSA = isUSA
        self.navigationController?.pushViewController(cityViewController, animated: true)
    }
    
    func showPlaceholderViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let placeholderViewController = storyboard.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController else { return }
        placeholderViewController.isUSA = isUSA
        placeholderViewController.selectedCity = city
         self.navigationController?.pushViewController(placeholderViewController, animated: true)
    }
    
    func showCreateTripPart2ViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let createTripViewControllerPart2 = storyboard.instantiateViewController(identifier: "CreateTripPart2ViewController") as? CreateTripPart2ViewController else { return }
        createTripViewControllerPart2.inUSA = isUSA
        createTripViewControllerPart2.city = city
        createTripViewControllerPart2.state = state
        createTripViewControllerPart2.country = countryName
        
        self.navigationController?.pushViewController(createTripViewControllerPart2, animated: true)
    }
    
    func navigateToMainTabBar() {
        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
        guard let mainTabBarViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController else { return }
        self.navigationController?.pushViewController(mainTabBarViewController, animated: true)
    }
}
