//
//  CurrencyExchangeViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/18/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class CurrencyExchangeViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var countryName: UILabel!
    
    var currencyExchangeRate: CurrencyExchangeRate?
    
    var amountToExchange: Double?
    var calcutedExchange: Double?
    //var trip = TripController.shared.tripForAllTabs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        amountTextField.placeholder = "Enter amount..."
        resultLabel.alpha = 0
        self.fetchCurrencyExchangeRate()
        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrencyExchangeRate()
    }
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        performCalculationUpdateViews()
        
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        amountTextField.resignFirstResponder()
    }
    
    func fetchCurrencyExchangeRate() {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        countryName.text = (trip.destinationCountryName ?? "") + " Currency Exchange"
        let search = TripController.shared.fetchAPIQueryString(trip: trip)
        
        CurrencyExchangeRateController.shared.fetchCurrencyExchangeRate(search: search) { (currencyExchange) in
            if let fetchedExchangeRate = currencyExchange {
                self.currencyExchangeRate = fetchedExchangeRate
                DispatchQueue.main.async {
                    self.currencyLabel.text = "1 \(trip.userCurrencyCode ?? "") = " + String(format: "%.2f", fetchedExchangeRate) + " \(trip.destinationCurrencyCode ?? "")"
                }
            }
        }
    }
    
    func performCalculationUpdateViews() {
        guard let trip = TripController.shared.tripForAllTabs,
            let exchangeRate = currencyExchangeRate else { return }
        
        // get the # the user entered
        guard let numberString = amountTextField.text, numberString != "", numberString != "0" else {
            return
        }
        let convertAmount = Double(numberString)
        self.amountToExchange = convertAmount
        guard let userInputAmount = amountToExchange else  { return }
        
        // multiply it by the exchange rate
        let calculatedAmount = userInputAmount * exchangeRate
        
        //let floatCalculatedAmount = Float(calculatedAmount)
        let calculatedString = calculatedAmount.formattedWithSeparator
        
        guard let destinationCurrencyCode = trip.destinationCurrencyCode else { return }
        let currencyName = CurrencyNameHelper.fetchCurrencyName(currencyCode: destinationCurrencyCode)
        
        // populate the calculated amount
        UIView.animate(withDuration: 2) {
            self.resultLabel.alpha = 1
            self.resultLabel.text = calculatedString + " " + currencyName
            
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolBar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .systemBlue
        let items = [flexSpace, done]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        
        amountTextField.inputAccessoryView = doneToolBar
    }
    
    @objc func doneButtonAction() {
        amountTextField.resignFirstResponder()
    }
}
extension CurrencyExchangeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resultLabel.alpha = 0
        textField.keyboardType = .numberPad
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
