//
//  EditTripViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/30/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class EditTripViewController: UIViewController {
    
    @IBOutlet weak var currentDetailsLabel: UILabel!
    
    @IBOutlet weak var newDateTextField: UITextField!
    
    @IBOutlet weak var newDurationTextField: UITextField!
    
    @IBOutlet weak var editTripButton: GrayButton!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var daysPicker: UIPickerView!
    
    var trip: Trip?
    var newTripDate: Date?
    //var newTripDuration: Int16?
    
    let durationPickerData = ["1 day", "2 days", "3 days", "4 days", "5 days", "6 days","7 days","8 days", "9 days", "10 days", "11 days", "12 days", "13 days", "14 days", "15 days", "16 days", "17 days", "18 days", "19 days", "20 days", "21 days", "22 days", "23 days", "24 days", "25 days", "26 days", "27 days", "28 days", "29 days", "30 days", "60 days", "90 days"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = true
        newDateTextField.inputView = datePicker
        newDateTextField.delegate = self
        newDateTextField.attributedPlaceholder = NSAttributedString(string: "Enter new date...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.hideKeyboardWhenTappedAround()
        
        daysPicker.delegate = self
        daysPicker.dataSource = self
        
        newDurationTextField.inputView = daysPicker
        newDurationTextField.delegate = self
        newDurationTextField.attributedPlaceholder = NSAttributedString(string: "Enter new length of stay...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        // add hide keyboard func
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateCurrentTripDetails()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newDatePickerChanged(_ sender: UIDatePicker) {
        //let dateChosenValue = datePicker.date
        newDateTextField.text = datePicker.date.stringValue()
        newTripDate = datePicker.date
    }
    
    
    @IBAction func editTripButtonTapped(_ sender: Any) {
        // complete get new dates and duration
        guard let currentTrip = trip else { return }
        let today = Date()
        if let selectedDate = newTripDate {
            if selectedDate < today, selectedDate != currentTrip.date {
                print("Selected date: \(selectedDate) & current date: \(String(describing: currentTrip.date))")
                self.presentUIHelperAlert(title: "Invalid Date", message: "Date entered has pasted or missing,\nenter a future date.")
                //return
            } else {
                // test this
                currentTrip.date = selectedDate
                TripController.shared.saveToPersistentStore()
            }
        }
        if let durationInDays = newDurationTextField.text {
            let numOfDays = durationInDays.replacingOccurrences(of: " days", with: "")
            let daysInt = Int16(numOfDays)
            // test
            if daysInt != nil {
                guard let daysDuration = daysInt else { return }
                currentTrip.durationInDays = daysDuration
                TripController.shared.saveToPersistentStore()
            } else {
                print("dont update duration, no input")
                //return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    func updateCurrentTripDetails() {
        guard let currentTrip = trip else { return }
        // add location, where is this at
        var countryOrState: String = ""
       // var currentCity: String = ""
        //var tripDate: Date?
        
        let currentDuration = currentTrip.durationInDays
        
        if currentTrip.inUSA == true {
            if let stateCode = currentTrip.destinationStateCode {
                countryOrState = TripController.shared.fetchStateFullName(code: stateCode)
                
            }
            
        } else {
            if let countryName = currentTrip.destinationCountryName {
             countryOrState = countryName
            }
        }
        
        if let currentTripDate = currentTrip.date,
            let cityName = currentTrip.destinationCity {
            //currentCity = cityName
            //tripDate = currentTripDate
            currentDetailsLabel.text = "Traveling to\n\(cityName), \(countryOrState)\non \(currentTripDate.stringValue())\nfor \(currentDuration) days"
        }
    
    }
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}
extension EditTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditTripViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newDurationTextField.text = durationPickerData[row]
        self.view.endEditing(true)
    }
}

extension EditTripViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
