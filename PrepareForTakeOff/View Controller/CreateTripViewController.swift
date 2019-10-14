//
//  CreateTripViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityStackView: UIStackView!
    
    
    @IBOutlet weak var placeHolderTableView: UITableView!
    @IBOutlet weak var placeHolderTextField: UITextField!
    @IBOutlet weak var placeHolderStackView: UIStackView!
    
    @IBOutlet weak var countrySelection: UISegmentedControl!
    
    // inUSA: city, State
    var city: String = ""
    var state: String = ""
    var isoCountryCode: String = ""
    var isUSA: Bool = true
    // Abroad: city, Country
    
    var isCitySearching = false
    var isPlaceHolderSearching = false
    
    var citySearchResults : [String] = []
    var placeHolderSearchResults : [String] = []
    
    var countryNames: [String] {
        // Turns cities.countries into a Set, which removes all duplicates, then turns it back into an Array and sorts alphabetically.
        // cities = $0
        return Array(Set(TripController.shared.cities.map({ $0.country }))).sorted()
    }
    var unitedStatesCityNames: [String] {
        let filteredCities = Array(Set(TripController.shared.cities.filter( {$0.country == "US"} ).map({$0.name}))).sorted()
        return filteredCities
    }
    
    var abroadCityNames: [String] {
        let filteredAbroadCities = Array(Set(TripController.shared.cities.filter( {$0.country != "US"} ).filter({$0.name != ""}).filter({$0.name != "-"}).map( {$0.name}))).sorted()
        return filteredAbroadCities
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cityStackView.isHidden = false
        countrySelection.selectedSegmentIndex = 0
        cityTextField.placeholder = "Enter city or county..."

        //updateViewsWithCountrySelection()
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTextField.delegate = self
       // cityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        placeHolderTableView.delegate = self
        placeHolderTableView.dataSource = self
        placeHolderTextField.delegate = self
       // stateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "stateCell")
        self.cityTextField.addTarget(self, action: #selector(citySearching), for: .touchDown)
        self.placeHolderTextField.addTarget(self, action: #selector(placeHolderSearching), for: .touchDown)
       // countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")
    }
    
    @IBAction func countrySelectionTapped(_ sender: UISegmentedControl) {
        self.placeHolderTextField.text = ""
        self.cityTextField.text = ""

        switch sender.selectedSegmentIndex {
        case 0:
            //inUSASelected()
            countrySelection.selectedSegmentIndex = 0
            DispatchQueue.main.async {
                self.cityTextField.placeholder = "Enter city or county..."
                self.placeHolderTextField.placeholder = "Enter State..."
                self.cityTableView.reloadData()
                self.placeHolderTableView.reloadData()
            }
        case 1:
            //inAbroadSelected()
            countrySelection.selectedSegmentIndex = 1
            DispatchQueue.main.async {
                self.cityTextField.placeholder = "Enter city..."
                self.placeHolderTextField.placeholder = "Enter Country..."
                self.cityTableView.reloadData()
                self.placeHolderTableView.reloadData()
            }
        default:
            print("nothing selected")
        }
    }
    
    @objc func citySearching(textField: UITextField) {
        isCitySearching = true
        cityStackView.isHidden = false
        isPlaceHolderSearching = false
        //placeHolderStackView.isHidden = true
        //placeHolderTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        
    }
    
    @objc func placeHolderSearching(textField: UITextField) {
        isPlaceHolderSearching = true
        placeHolderStackView.isHidden = false
        isCitySearching = false
        cityStackView.isHidden = true
        placeHolderSearchResults = TripController.shared.fetchStates()
    }
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        cityTextField.resignFirstResponder()
        placeHolderTextField.resignFirstResponder()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        
        guard let userCityText = cityTextField.text, !userCityText.isEmpty,
            let userPlaceHolderText = placeHolderTextField.text, !userPlaceHolderText.isEmpty else {
                presentUIHelperAlert(title: "Missing Info", message: "Invalid destination entry, please enter all fields.")
                return
        }
        city = userCityText
        // check if inUSA and Abroad Criteria - city / placeholder
        // USA selected
        if countrySelection.selectedSegmentIndex == 0 {
            // get state code
            let stateCode = TripController.shared.fetchStateCode(stateFullName: userPlaceHolderText)
            state = stateCode
            isoCountryCode = "US"
            isUSA = true
            
            // Abroad Selected
        } else if countrySelection.selectedSegmentIndex == 1 {
            let countryCode = TripController.shared.fetchCountryCode(countryFullName: userPlaceHolderText)
            // TODO: add an alert if it doesnt complete with a valid country code
            isoCountryCode = countryCode
            isUSA = false
        }
        // push navigation controller vc
        showCreateTripPart2ViewController()
        
    }
    
    // Helper Func for UI Alert
    func presentUIHelperAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
    func showCreateTripPart2ViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let createTripViewControllerPart2 = storyboard.instantiateViewController(identifier: "CreateTripPart2ViewController") as? CreateTripPart2ViewController else { return }
        createTripViewControllerPart2.city = city
        createTripViewControllerPart2.state = state
        createTripViewControllerPart2.isoCountryCode = isoCountryCode
        createTripViewControllerPart2.inUSA = isUSA
        self.navigationController?.pushViewController(createTripViewControllerPart2, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateTripViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if tableView == self.cityTableView {
            if countrySelection.selectedSegmentIndex == 0, isCitySearching == false {
                count = unitedStatesCityNames.count
            } else if countrySelection.selectedSegmentIndex == 1, isCitySearching == false {
                count = abroadCityNames.count
            } else if isCitySearching == true {
                count = citySearchResults.count
                
            }
            
        } else if tableView == self.placeHolderTableView {
            if countrySelection.selectedSegmentIndex == 0, isPlaceHolderSearching == false {
                count = TripController.shared.fetchStates().count
            } else if countrySelection.selectedSegmentIndex == 1, isPlaceHolderSearching == false {
                count =  countryNames.count
            } else if isPlaceHolderSearching == true {
                count = placeHolderSearchResults.count
            }
        }
        return count
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.cityTableView {
            let cell = tableView.cellForRow(at: indexPath)
            let cityText = cell?.textLabel?.text
            cityTextField.text = cityText
            // TODO: search in JSON file, for the city and populate state
            
            // placeholder.text = resultCountry
        } else if tableView == self.placeHolderTableView {
            let cell = tableView.cellForRow(at: indexPath)
            let placeHolderText = cell?.textLabel?.text
            placeHolderTextField.text = placeHolderText
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.cityTableView, countrySelection.selectedSegmentIndex == 0, isCitySearching == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let city = unitedStatesCityNames[indexPath.row]
            cell.textLabel?.text = city
            return cell
        } else if tableView == self.cityTableView, countrySelection.selectedSegmentIndex == 1, isCitySearching == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let city = abroadCityNames[indexPath.row]
            cell.textLabel?.text = city
            return cell
            
        } else if tableView == self.cityTableView, isCitySearching == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let city = citySearchResults[indexPath.row]
            cell.textLabel?.text = city
            return cell
        } else if tableView == self.placeHolderTableView, countrySelection.selectedSegmentIndex == 0, isPlaceHolderSearching == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeHolderCell", for: indexPath)
            // key
            let state = TripController.shared.fetchStates()[indexPath.row]
            //cell.textLabel?.text = StateHelper.states[state]
            cell.textLabel?.text = state
            return cell
        } else if tableView == self.placeHolderTableView, countrySelection.selectedSegmentIndex == 0, isPlaceHolderSearching == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeHolderCell", for: indexPath)
            let searchedState = placeHolderSearchResults[indexPath.row]
            cell.textLabel?.text = searchedState
            return cell
        } else if tableView == self.placeHolderTableView, countrySelection.selectedSegmentIndex == 1, isPlaceHolderSearching == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeHolderCell", for: indexPath)
            // 2 Letter country code
            let countryCode = countryNames[indexPath.row]
            // index of 2 Letter region codes
            let indexOfCountryCode = Locale.isoRegionCodes.firstIndex(of: countryCode) ?? 0
            // 2 Letter region code
            let countryName = Locale.isoRegionCodes[indexOfCountryCode]
            let countryDisplayName = NSLocale.current.localizedString(forRegionCode: countryName)
            //cell.textLabel?.text = country.country
            cell.textLabel?.text = countryDisplayName
            return cell
        } else if tableView == self.placeHolderTableView, countrySelection.selectedSegmentIndex == 1, isPlaceHolderSearching == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeHolderCell", for: indexPath)
            let countryCode = placeHolderSearchResults[indexPath.row]
            let index = Locale.isoRegionCodes.firstIndex(of: countryCode) ?? 0
            let country = Locale.isoRegionCodes[index]
            let countryName = Locale.current.localizedString(forRegionCode: country)
            cell.textLabel?.text = countryName
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension CreateTripViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
       // textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else { return }
        let count = searchText.count
        print(searchText)
        if isCitySearching == true, countrySelection.selectedSegmentIndex == 0 {
            citySearchResults = unitedStatesCityNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
            self.cityTableView.reloadData()
        } else if isCitySearching == true, countrySelection.selectedSegmentIndex == 1 {
            citySearchResults = abroadCityNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
            self.cityTableView.reloadData()
        } else if isPlaceHolderSearching == true, countrySelection.selectedSegmentIndex == 0 {
            placeHolderSearchResults = TripController.shared.fetchStates().filter({$0.prefix(count).lowercased() == searchText}).sorted()
            self.placeHolderTableView.reloadData()
        } else if isPlaceHolderSearching == true, countrySelection.selectedSegmentIndex == 1 {
            placeHolderSearchResults = countryNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
            self.placeHolderTableView.reloadData()
        }
        
    }
}
