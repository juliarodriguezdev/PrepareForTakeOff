//
//  CreateTripPart2ViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/9/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CreateTripPart2ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var city: String?
    var state: String?
    var isoCountryCode: String?
    var isoDestinationCurrencyCode: String?
    var inUSA: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
        nameTextField.delegate = self
        self.addDoneButtonOnKeyboard()

    }

    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        let dateChosenValue = datePicker.date
        dateTextField.text = dateChosenValue.stringValue()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let city = city,
            let isoCountryCode = isoCountryCode,
            let destinationCurrencyCode = isoDestinationCurrencyCode,
            let isUSA = inUSA else { return }
    
        let destinationCountryName = NSLocale.current.localizedString(forRegionCode: isoCountryCode)
        // get date, check if it not < current date
        let today = Date()
        let dateOfTrip = datePicker.date
        // TODO: Test if today work on simulator
        if dateOfTrip < today {
            self.presentUIHelperAlert(title: "Invalid Date", message: "Date entered is in the past, enter a future date.")
            return
        }
        guard let tripName = nameTextField.text, !tripName.isEmpty else {
            self.presentUIHelperAlert(title: "Missing Trip Name", message: "Please enter a trip name, occasion and continue.")
            return
        }
        // check for usa and abroad
        if isUSA == true {
            guard let state = state else { return }
            
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName ?? isoCountryCode, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: state, inUSA: true, name: tripName)
            print("Trip for USA was created")
        } else {
            // USA == false; abroad Trip (no state)
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName ?? isoCountryCode, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: nil, inUSA: false, name: tripName)
            print("Trip for abroad was created")
        }
        // show main trip VC
        showMainTripViewController()
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        nameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
    }
    
    // Helper Func for UI Alert
    func presentUIHelperAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
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
        
        nameTextField.inputAccessoryView = doneToolBar
        dateTextField.inputAccessoryView = doneToolBar
    
    }
    
    @objc func doneButtonAction() {
        nameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
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

extension CreateTripPart2ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}
