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
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var durationPicker: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var city: String?
    var state: String?
    var isoCountryCode: String?
    var isoDestinationCurrencyCode: String?
    var inUSA: Bool?
    
    let durationPickerData = ["1 day", "2 days", "3 days", "4 days","5 days", "6 days","7 days","8 days", "9 days", "10 days", "11 days", "12 days", "13 days", "14 days", "15 days", "16 days", "17 days", "18 days", "19 days", "20 days", "21 days", "22 days", "23 days", "24 days", "25 days", "26 days", "27 days", "28 days", "29 days", "30 days", "60 days", "90 days"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
        nameTextField.delegate = self
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        durationTextField.inputView = durationPicker
        durationTextField.delegate = self
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
        
        guard let durationDays = durationTextField.text else { return }
        let numberOfDays = durationDays.replacingOccurrences(of: " days", with: "")
        // test: trimming white spaces
        let daysInt = Int16(numberOfDays)
        print("Days from picker is: \(daysInt ?? 0)")
        
        // check for usa and abroad
        if isUSA == true {
            guard let state = state else { return }
            
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName ?? isoCountryCode, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: state, inUSA: true, name: tripName, durationInDays: daysInt ?? 1)
            scheduleNotification(notificationTitle: "Upcoming Trip Tomorrow", notificationBody: "Don't forget to pack ID, phone charger, & toothbrush", tripDate: dateOfTrip)
            print("Trip for USA was created")
        } else {
            // USA == false; abroad Trip (no state)
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName ?? isoCountryCode, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: nil, inUSA: false, name: tripName, durationInDays: daysInt ?? 1)
            scheduleNotification(notificationTitle: "Upcoming Trip Tomorrow", notificationBody: "Don't forget to pack passport, phone charger, & toothbrush", tripDate: dateOfTrip)
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
    
    func scheduleNotification(notificationTitle: String, notificationBody: String, tripDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default
        content.badge = 1
        
        //let tripDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tripDate)
        if let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: tripDate) {
            
            var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .second], from: triggerDate)
            triggerDateComponents.hour = 20
            triggerDateComponents.minute = 42
           // TODO: Add time to send notification, picker - time
            // triggerDateComponents.hour = 8
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            
            let request = UNNotificationRequest(identifier: "1dayBeforeTrip", content: content, trigger: notificationTrigger)
            
            UNUserNotificationCenter.current().add(request) { (_) in
                print("User asked for a local notification")
            }
        
        }
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
    
    }
    
    @objc func doneButtonAction() {
        nameTextField.resignFirstResponder()
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationTextField.text = durationPickerData[row]
        self.view.endEditing(true)
    }
    
    
}
