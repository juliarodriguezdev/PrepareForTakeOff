//
//  CityViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var nextButton: GrayButton!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var noSearchLabel: UILabel!
    @IBOutlet weak var okButton: GrayButton!
    
    // send is abroad boolean, landing pad
    var isUSA: Bool?
    var city: String = ""
    var isCitySearching = false
    var countryGuess: String?
    var citySearchResults : [String] = []
    
    var didShowPopUp: Bool = false
    var userDidSelectCity: Bool = false

    var unitedStatesCityNames: [String] {
           let filteredCities = Array(Set(CityResultsController.shared.cities.filter( {$0.country == "US"} ).map({$0.name}))).sorted()
           return filteredCities
       }
    
    var abroadCityNames: [String] {
           let filteredAbroadCities = Array(Set(CityResultsController.shared.cities.filter( {$0.country != "US"} ).filter({$0.name != ""}).filter({$0.name != "-"}).map( {$0.name}))).sorted()
           return filteredAbroadCities
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = true
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.backgroundColor = UIColor.travelBackground
        cityTextField.delegate = self
        
        noSearchLabel.text = "Continue typing city\n& select 'Next'\nto proceed"
        noSearchLabel.textColor = .black
        popUpView.backgroundColor = .white
        popUpView.alpha = 0.95
        popUpView.addCornerRadius(25)
      
        nextButton.setTitle("Next", for: .normal)
        self.addDoneButtonOnKeyboard()
        self.cityTextField.addTarget(self, action: #selector(citySearching), for: .touchDown)
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //self.tabBarController?.tabBar.isHidden = true
        var text: String = ""
        if isUSA == true {
            //cityTextField.placeholder = "Enter United States City..."
            text = "Enter United States city..."
        } else {
            //cityTextField.placeholder = "Enter Abroad City"
            text = "Enter abroad city..."
        }
        cityTextField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        didShowPopUp = false
        userDidSelectCity = false
        popUpView.isHidden = true
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let userCityText = cityTextField.text, !userCityText.isEmpty else {
           presentUIHelperAlert(title: "Missing Info", message: "Invalid destination city entry, please try again.")
            return
        }
        city = userCityText
        // if USA, -> Go to States VC
        if isUSA == true {
            presentStatesViewController()
        } else if userDidSelectCity == true {
            presentAbroadPredictionViewController()
        } else if userDidSelectCity == false {
            presentCountryListViewContrller()
        }
        
        // else if Abroad -> Go to Abroad PlaceHolder Prediction VC
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .black
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        cityTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        cityTextField.resignFirstResponder()
    }
    
    @objc func citySearching(_ textField: UITextField) {
        isCitySearching = true
    }
    
    func presentStatesViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let allStatesViewController = storyboard.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController else { return }
        allStatesViewController.isUSA = isUSA
        allStatesViewController.selectedCity = city
        self.navigationController?.pushViewController(allStatesViewController, animated: true)
        
    }
    
    func presentCountryListViewContrller() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let countryListViewController = storyboard.instantiateViewController(withIdentifier: "PlaceholderViewController") as? PlaceholderViewController else { return }
        // check this is false
        countryListViewController.isUSA = isUSA
        countryListViewController.selectedCity = city
        self.navigationController?.pushViewController(countryListViewController, animated: true)
    }
    func presentAbroadPredictionViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let abroadPredictionViewController = storyboard.instantiateViewController(withIdentifier: "AbroadPredictionViewController") as? AbroadPredictionViewController else { return }
        abroadPredictionViewController.selectedCity = city
        abroadPredictionViewController.isUSA = isUSA
        abroadPredictionViewController.predictedCountry = countryGuess
        self.navigationController?.pushViewController(abroadPredictionViewController, animated: true)
    }
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }

}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if isUSA == true, isCitySearching == false {
            count = unitedStatesCityNames.count
        } else if isUSA == false, isCitySearching == false {
            count = abroadCityNames.count
        } else if isCitySearching == true {
            count = citySearchResults.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        // in USA, not searching
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        var specificCity: String?
        if isUSA == true, isCitySearching == false {
            specificCity = unitedStatesCityNames[indexPath.row]
            // in USA, searching
        } else if isUSA == true, isCitySearching == true {
            specificCity = citySearchResults[indexPath.row]
            // Abroad Countries, not searching
        } else if isUSA == false, isCitySearching == false {
            specificCity = abroadCityNames[indexPath.row]
            // Abroad Countries, searching
        } else if isUSA == false, isCitySearching == true {
            specificCity = citySearchResults[indexPath.row]
        }
        
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: FontNames.nunitoLight , size: 14.5)
        cell.textLabel?.text = specificCity
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        guard let cityText = cell?.textLabel?.text, !cityText.isEmpty else { return }
        cityTextField.text = cityText
       // city = cityText
        print("didSelectRowAt: \(cityText)")
        userDidSelectCity = true
        cityTextField.resignFirstResponder()
        
        if isUSA == false {
            let object = CityResultsController.shared.cities.filter({$0.name == cityText}).map({$0.country})
            if let objectIndex = object.first {
                let indexOfCountryCode = Locale.isoRegionCodes.firstIndex(of: objectIndex) ?? 0
                // 2 letter region code
                let countryName = Locale.isoRegionCodes[indexOfCountryCode]
                let countryDisplayName = NSLocale.current.localizedString(forRegionCode: countryName)
                countryGuess = countryDisplayName
            }
        }
    }
    
    
}

extension CityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else { return }
        let count = searchText.count
        print("Textfield searchText: \(searchText)")
        userDidSelectCity = false
        
        if isCitySearching == true, isUSA == true {
            citySearchResults = unitedStatesCityNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
        } else if isCitySearching == true, isUSA == false {
            citySearchResults = abroadCityNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
        }
        self.cityTableView.reloadData()
        
        if cityTableView.visibleCells.isEmpty && didShowPopUp == false {
            UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
                self.popUpView.isHidden = false
            }, completion: nil)
            
            didShowPopUp = true
        }
    }
    
}
