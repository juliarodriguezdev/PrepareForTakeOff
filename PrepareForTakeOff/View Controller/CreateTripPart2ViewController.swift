//
//  CreateTripPart2ViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import UserNotifications

class CreateTripPart2ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var durationTextField: UITextField!
        
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var durationPicker: UIPickerView!
    
    @IBOutlet weak var saveButton: GrayButton!
    
    // landing pad
    var inUSA: Bool?
    var city: String?
    
    // use this one to unwrap to send to API Call
    var state: String?
    // use this as the country to unwrap for API Call
    var country: String?
    //var stateCode: String?
    //var isoCountryCode: String?
    //var isoDestinationCurrencyCode: String?
    
    // new variables
    var tripDate: Date?
    var tripDuration: Int16?
    
    let durationPickerData = ["1 day", "2 days", "3 days", "4 days","5 days", "6 days","7 days","8 days", "9 days", "10 days", "11 days", "12 days", "13 days", "14 days", "15 days", "16 days", "17 days", "18 days", "19 days", "20 days", "21 days", "22 days", "23 days", "24 days", "25 days", "26 days", "27 days", "28 days", "29 days", "30 days", "60 days", "90 days"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = true
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
        dateTextField.attributedPlaceholder = NSAttributedString(string: "Enter Date...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.hideKeyboardWhenTappedAround()
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        durationTextField.inputView = durationPicker
        durationTextField.delegate = self
        durationTextField.attributedPlaceholder = NSAttributedString(string: "Enter length...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.addDoneButtonOnKeyboard()

    }

    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        let dateChosenValue = datePicker.date
        dateTextField.text = dateChosenValue.stringValue()
        //self.view.endEditing(true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // assign date
        tripDate = datePicker.date
        let today = Date()
        guard let selectedDate = tripDate else { return }
        if selectedDate < today {
            print("Selected date: \(selectedDate) and today: \(today)")
            self.presentUIHelperAlert(title: "Invalid Date", message: "Date entered has pasted or missing,\nenter a future date.")
            return
        }
        // assign duration
        guard let durationDays = durationTextField.text else { return }
               let numberOfDays = durationDays.replacingOccurrences(of: " days", with: "")
               // test: trimming white spaces
               let daysInt = Int16(numberOfDays)
        if daysInt == nil {
            self.presentUIHelperAlert(title: "Missing Info", message: "Length of stay is missing,\nselect a quantity")
            return
        }
        tripDuration = daysInt
        print("Days from picker is: \(String(describing: daysInt))")
        
        showFinalizeTripViewController()
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    // Helper Func for UI Alert
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
    func showFinalizeTripViewController() {
        let storyboard = UIStoryboard(name: "CreateTrip", bundle: nil)
        guard let finalizeTripViewController = storyboard.instantiateViewController(withIdentifier: "FinalizeTripViewController") as? FinalizeTripViewController else { return }
        finalizeTripViewController.inUSA = inUSA
        finalizeTripViewController.city = city
        finalizeTripViewController.state = state
        finalizeTripViewController.country = country
        finalizeTripViewController.dateOfTrip = tripDate
        finalizeTripViewController.durationInDays = tripDuration
        self.navigationController?.pushViewController(finalizeTripViewController, animated: true)
    }
    
    func showMainTripViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        done.tintColor = .systemBlue
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        
       // nameTextField.inputAccessoryView = doneToolBar
    
    }
    
    @objc func doneButtonAction() {
        dateTextField.resignFirstResponder()
    }

}

extension CreateTripPart2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}

extension CreateTripPart2ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
         var pickerLabel: UILabel? = (view as? UILabel)
           if pickerLabel == nil {
               pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: FontNames.nunitoSemiBold, size: 18.0)
               pickerLabel?.textAlignment = .center
           }
           pickerLabel?.text = durationPickerData[row]
           //pickerLabel?.textColor = UIColor.blue

           return pickerLabel!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationTextField.text = durationPickerData[row]
        self.view.endEditing(true)
    }
    
    
}
extension CreateTripPart2ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateTripPart2ViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
