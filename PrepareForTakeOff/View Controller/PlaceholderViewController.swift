//
//  PlaceholderViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class PlaceholderViewController: UIViewController {

    @IBOutlet weak var placeholderTextField: UITextField!
    @IBOutlet weak var placeholderTableView: UITableView!
    @IBOutlet weak var nextButton: GrayButton!
    
    // landing pad from previous view controller
    var isUSA: Bool?
    var selectedCity: String?
    
    var isoCountryCode: String = ""
    var isoDestinationCurrencyCode: String = ""
    var isPlaceholderSearching = false
    var placeholderSearchResults : [String] = []
    
    var countryNames: [String] {
        let countries = Array(Set(CityResultsController.shared.cities.filter({$0.country != "US"}).map({$0.country}))).sorted()
        return countries
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        placeholderTableView.delegate = self
        placeholderTableView.dataSource = self
        placeholderTableView.backgroundColor = UIColor.travelBackground
        
        placeholderTextField.delegate = self
        nextButton.setTitle("Continue", for: .normal)
        self.addDoneButtonOnKeyboard()
        self.placeholderTextField.addTarget(self, action: #selector(placeholderSearching(_:)), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        var text: String = ""
        if isUSA == true {
            text = "Enter State..."
        } else {
            text = "Enter Country..."
        }
        placeholderTextField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func placeholderSearching(_ textField: UITextField) {
        isPlaceholderSearching = true
        if isUSA == true {
            placeholderSearchResults = TripController.shared.fetchStates()
        } else {
            let countryFullNames = countryNames.compactMap({Locale.current.localizedString(forRegionCode: $0)})
            placeholderSearchResults = countryFullNames
        }
    }
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .black
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        placeholderTextField.inputAccessoryView = doneToolBar
    }
    
    @objc func doneButtonAction() {
        placeholderTextField.resignFirstResponder()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let placeholder = placeholderTextField.text, !placeholder.isEmpty else {
                  presentUIHelperAlert(title: "Missing Info", message: "Invalid destination entry, please try again.")
                  return }
        if segue.identifier == "toReviewTripVC" {
            let destinationVC = segue.destination as? CreateTripViewController
            
            destinationVC?.city = selectedCity ?? ""
            if isUSA == true {
                destinationVC?.isUSA = true
                destinationVC?.state = placeholder
            } else {
                destinationVC?.isUSA = false
                destinationVC?.countryName = placeholder
            }
        }
    }
}

extension PlaceholderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased() else { return }
        let count = searchText.count
        print(searchText)
        
        if isPlaceholderSearching == true, isUSA == true {
            placeholderSearchResults = TripController.shared.fetchStates().filter({$0.prefix(count).lowercased() == searchText}).sorted()
        } else if isPlaceholderSearching == true, isUSA == false {
            let countryFullNames = countryNames.compactMap({Locale.current.localizedString(forRegionCode: $0)})
            placeholderSearchResults = countryFullNames.filter({$0.prefix(count).lowercased() == searchText}).sorted()
        }
        self.placeholderTableView.reloadData()
    }
}
extension PlaceholderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if isUSA == true, isPlaceholderSearching == false {
            count = TripController.shared.fetchStates().count
        } else if isUSA == false, isPlaceholderSearching == false {
            count = countryNames.count
        } else if isPlaceholderSearching == true {
            count = placeholderSearchResults.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: us gaurd let, else UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeHolderCell", for: indexPath)
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        var placeholder: String?
        
        if isUSA == true, isPlaceholderSearching == false {
            placeholder = TripController.shared.fetchStates()[indexPath.row]
        } else if isUSA == true, isPlaceholderSearching == true {
            placeholder = placeholderSearchResults[indexPath.row]
        } else if isUSA == false, isPlaceholderSearching == false {
            let countryCode = countryNames[indexPath.row]
            let indexOfCOuntryCode = Locale.isoRegionCodes.firstIndex(of: countryCode) ?? 0
            let countryName = Locale.isoRegionCodes[indexOfCOuntryCode]
            placeholder = NSLocale.current.localizedString(forRegionCode: countryName)
        } else if isUSA == false, isPlaceholderSearching == true {
            placeholder = placeholderSearchResults[indexPath.row]
        }
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: FontNames.nunitoLight, size: 14.5)
        cell.textLabel?.text = placeholder
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let placeholderText = cell?.textLabel?.text, !placeholderText.isEmpty else { return }
        placeholderTextField.text = placeholderText
        placeholderTextField.resignFirstResponder()
    }
}
