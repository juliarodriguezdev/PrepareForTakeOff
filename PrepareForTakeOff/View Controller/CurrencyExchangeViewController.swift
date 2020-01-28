//
//  CurrencyExchangeViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/18/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class CurrencyExchangeViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
        
    @IBOutlet weak var indicatorWheel: UIActivityIndicatorView!
    
    @IBOutlet weak var comparisonBackground: UIImageView!
    
    @IBOutlet weak var comparisonDivider: UIImageView!
    
    @IBOutlet weak var calculateBackground: UIImageView!
    
    @IBOutlet weak var calculateDivider: UIImageView!
    // from home Country, user Currency Exchange Rate
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var calculateButton: WhiteButton!
    // say enjoy your trip
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var paperPlaneImage: UIImageView!
    
    @IBOutlet weak var trailImage: UIImageView!
    
    @IBOutlet weak var countrySelection: UISegmentedControl!
    
    @IBOutlet weak var destinationAmountInputTextField: UITextField!
    
    var currencyExchangeRate: CurrencyExchangeRate?
    
    var amountToExchange: Double?
    var calcutedExchange: Double?
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "CurrencyExchangeMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.delegate = self
        amountTextField.attributedPlaceholder = NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        amountTextField.textAlignment = .center
        amountTextField.borderStyle = .none
        destinationAmountInputTextField.delegate = self
        destinationAmountInputTextField.attributedPlaceholder = NSAttributedString(string: "Amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        destinationAmountInputTextField.textAlignment = .center
        destinationAmountInputTextField.borderStyle = .none
        resultLabel.alpha = 0
        //exchangeResult.alpha = 0
        paperPlaneImage.alpha = 0
        trailImage.alpha = 0
        self.view.backgroundColor = UIColor.travelBackground
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //self.fetchCurrencyExchangeRate()
        //self.addDoneButtonOnKeyboard()
        self.hideKeyboardWhenTappedAround()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paperPlaneImage.alpha = 0
        trailImage.alpha = 0
        countrySelection.selectedSegmentIndex = 0
        indicatorWheel.startAnimating()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.updateWithCountrySelection()
                }
                print("Network connection is available")
            } else {
                print("No network connection")
            }
        }
        monitor.start(queue: queue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchCurrencyExchangeRate()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
    }
    
    @IBAction func countrySelectionTapped(_ sender: Any) {
        updateWithCountrySelection()
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        
        performCalculationUpdateViews()
        
    }
    
    func updateWithCountrySelection() {
        
        if countrySelection.selectedSegmentIndex == 0 {
            destinationAmountInputTextField.alpha = 0

            amountTextField.alpha = 1
            amountTextField.isUserInteractionEnabled = true
            amountTextField.becomeFirstResponder()
        } else {
        
            amountTextField.alpha = 0
            
            destinationAmountInputTextField.alpha = 1
            destinationAmountInputTextField.isUserInteractionEnabled = true
            destinationAmountInputTextField.becomeFirstResponder()
        }
    }
    
    
    func fetchCurrencyExchangeRate() {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        countryName.text = (trip.destinationCountryName ?? "") + " Currency Exchange"
        
        if self.monitor.currentPath.status == .satisfied {
            if trip.userCurrencyCode != trip.destinationCurrencyCode {
                let fingerPaintFont = UIFont(name: FontNames.fingerPaintRegular, size: 24.0)
                countrySelection.setTitleTextAttributes([NSAttributedString.Key.font: fingerPaintFont!], for: .normal)
                countrySelection.setTitle(trip.userCurrencyCode, forSegmentAt: 0)
                countrySelection.setTitle(trip.destinationCurrencyCode, forSegmentAt: 1)
                
                let search = TripController.shared.fetchAPIQueryString(trip: trip)
                print("The Search $X is: \(search)")
                CurrencyExchangeRateController.shared.fetchCurrencyExchangeRate(search: search) { (currencyExchange) in
                    if let fetchedExchangeRate = currencyExchange {
                        self.currencyExchangeRate = fetchedExchangeRate
                        DispatchQueue.main.async {
                            self.indicatorWheel.stopAnimating()
                           // self.amountTextField.becomeFirstResponder()
                            self.currencyLabel.text = "1 \(trip.userCurrencyCode ?? "") = " + String(format: "%.2f", fetchedExchangeRate) + " \(trip.destinationCurrencyCode ?? "")"
                            self.resultLabel.alpha = 0
                            self.comparisonBackground.isHidden = false
                            self.comparisonDivider.isHidden = false
                           
                            self.calculateBackground.isHidden = false
                            self.calculateDivider.isHidden = false
                            self.calculateButton.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.noResultsDisplay(resultText: "Apologies, couldn't retrieve exchange rate")
                            if trip.inUSA == true {
                                if let destCity = trip.destinationCity,
                                    let destState = trip.destinationStateCode {
                                    let stateName = TripController.shared.fetchStateFullName(code: destState)
                                    self.currencyLabel.text = "\(destCity), \(stateName)"
                                }
                            } else {
                                if let destCity = trip.destinationCity,
                                    let destCountry = trip.destinationCountryName {
                                    self.currencyLabel.text = "\(destCity), \(destCountry)"
                                }
                            }
                        }
                    }
                }
            } else {
                noResultsDisplay(resultText: "No Currency to Exchange,\nenjoy your trip!")
              
                if trip.inUSA == true {
                    if let cityName = trip.destinationCity,
                        let stateCode = trip.destinationStateCode,
                        let userCurrency = trip.userCurrencyCode {
                        let stateFullName = TripController.shared.fetchStateFullName(code: stateCode)
                        currencyLabel.text = "\(cityName), \(stateFullName) uses \(userCurrency)"
                    }
                } else {
                    if let cityName = trip.destinationCity,
                        let destCountry = trip.destinationCountryName,
                        let userCurrency = trip.userCurrencyCode {
                        currencyLabel.text = "\(cityName), \(destCountry) uses \(userCurrency)"
                    }
                }
            }
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.indicatorWheel.stopAnimating()
            self.noResultsDisplay(resultText: "No internet connection,\nplease enable on your device.")
            
            if trip.inUSA == true {
                if let destCity = trip.destinationCity,
                    let destState = trip.destinationStateCode {
                    let stateName = TripController.shared.fetchStateFullName(code: destState)
                    self.currencyLabel.text = "\(destCity), \(stateName)"
                }
            } else {
                if let destCity = trip.destinationCity,
                    let destCountry = trip.destinationCountryName {
                    self.currencyLabel.text = "\(destCity), \(destCountry)"
                }
            }
            
        }
        
        
    }
    
     @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2.8
               }
           }
       }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func noResultsDisplay(resultText: String) {
        self.indicatorWheel.stopAnimating()
        self.comparisonBackground.isHidden = true
        self.comparisonDivider.isHidden = true
        self.countrySelection.isHidden = true
        self.calculateBackground.isHidden = true
        self.calculateDivider.isHidden = true
        self.amountTextField.alpha = 0
        self.destinationAmountInputTextField.alpha = 0
        self.calculateButton.isHidden = true
        self.paperPlaneImage.alpha = 1
        self.trailImage.alpha = 1
        self.resultLabel.alpha = 1
        resultLabel.text = resultText
        self.countryName.text = "Currency Exchange"
        
    }
    
    func performCalculationUpdateViews() {
        guard let trip = TripController.shared.tripForAllTabs,
            let exchangeRate = currencyExchangeRate else { return }
        
        if countrySelection.selectedSegmentIndex == 0 {
            // get the # the user entered
            guard let numberString = amountTextField.text, !numberString.isEmpty, numberString != "0" else {
                return
            }
            let removeCommasString = numberString.replacingOccurrences(of: ",", with: "")
            let convertAmount = Double(removeCommasString)
            self.amountToExchange = convertAmount
            guard let userInputAmount = amountToExchange else  { return }
            
            // multiply it by the exchange rate
            let calculatedAmount = userInputAmount * exchangeRate
            
            //let floatCalculatedAmount = Float(calculatedAmount)
            let calculatedString = calculatedAmount.formattedWithSeparator
            
            // get info from labels
            guard let destinationCurrencyCode = trip.destinationCurrencyCode else { return }
            let currencyName = CurrencyNameHelper.fetchCurrencyName(currencyCode: destinationCurrencyCode)
            
            // populate the calculated amount
            UIView.animate(withDuration: 1.5) {
                self.resultLabel.alpha = 1
                self.resultLabel.text = calculatedString + " " + currencyName
                self.destinationAmountInputTextField.alpha = 1
                self.destinationAmountInputTextField.isUserInteractionEnabled = false
                //self.destinationAmountInputTextField.isEnabled = false
                self.destinationAmountInputTextField.text = calculatedString
                //self.exchangeResult.alpha = 1
                //self.exchangeResult.text = calculatedString
                
            }
            
        } else {
            guard let numberString = destinationAmountInputTextField.text, !numberString.isEmpty, numberString != "0" else {
                return
            }
            let removeCommasString = numberString.replacingOccurrences(of: ",", with: "")
            let convertAmount = Double(removeCommasString)
            self.amountToExchange = convertAmount
            guard let userInputAmount = amountToExchange else  { return }
            
            // multiply it by the exchange rate
            let calculatedAmount = userInputAmount / exchangeRate
            
            //let floatCalculatedAmount = Float(calculatedAmount)
            let calculatedString = calculatedAmount.formattedWithSeparator
            
            // get info from labels
            guard let userCurrencyCode = trip.userCurrencyCode else { return }
            let currencyName = CurrencyNameHelper.fetchCurrencyName(currencyCode: userCurrencyCode)
            
            UIView.animate(withDuration: 1.3) {
                self.resultLabel.alpha = 1
                self.resultLabel.text = calculatedString + " " + currencyName
                self.amountTextField.alpha = 1
                self.amountTextField.isUserInteractionEnabled = false
                self.amountTextField.text = calculatedString
            }
            
            
        }
        
    }
}
extension CurrencyExchangeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //resultLabel.alpha = 0
        textField.text = ""
        textField.keyboardType = .numberPad
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            let commaText = Double(text)?.formattedWithSeparator
            textField.text = commaText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CurrencyExchangeViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
