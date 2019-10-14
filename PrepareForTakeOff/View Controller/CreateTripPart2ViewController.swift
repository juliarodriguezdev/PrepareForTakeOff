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
    var inUSA: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.inputView = datePicker

    }
    
    
    @IBAction func datePickerTapped(_ sender: UIDatePicker) {
        let dateChosenValue = datePicker.date
        dateTextField.text = dateChosenValue.stringValue()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let city = city,
            let isoCountryCode = isoCountryCode,
            let isUSA = inUSA else { return }
    
        let destinationCurrencyCode = TripController.shared.fetchCountryCurrencyCode(isoCountryCode: isoCountryCode)
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
            
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName!, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: state, inUSA: true, name: tripName)
            print("Trip for USA was created")
        } else {
            // USA == false; abroad Trip (no city)
            TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: isoCountryCode, destinationCountryName: destinationCountryName!, destinationCurrencyCode: destinationCurrencyCode, destinationStateCode: nil, inUSA: false, name: tripName)
            print("Trip for abroad was created")
        }
        // show main trip VC
        showMainTripViewController()
        
        
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
    
    func showMainTripViewController() {
//        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
//        guard let mainTripViewController = storyboard.instantiateViewController(identifier: "TripViewController") as? TripViewController else { return }
        self.navigationController?.popToRootViewController(animated: true)
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
