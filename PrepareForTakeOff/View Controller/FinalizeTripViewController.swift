//
//  FinalizeTripViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import UserNotifications
import Network

class FinalizeTripViewController: UIViewController {

    @IBOutlet weak var destinationPhoto: UIImageView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var createTripButton: GrayButton!
    @IBOutlet weak var indicatorWheel: UIActivityIndicatorView!
    
    // landing pad
    var inUSA: Bool?
    var city: String?
    // for in usa
    var state: String?
    // for abroad
    var country: String?
        
    var dateOfTrip: Date?
    var durationInDays: Int16?
    var userTripName: String?
    
    // api results
    var destinationResults: [DestinationInfo] = []
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "FinalizeTripMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.tabBarController?.tabBar.isHidden = true
        indicatorWheel.hidesWhenStopped = true
        tripNameTextField.delegate = self
        tripNameTextField.placeholder = "Enter trip name, occasion, description..."
        suggestTripName()
    
        self.hideKeyboardWhenTappedAround()
        // add destination city, State or city, Country as the textfield input
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    // move the keyboard with the textfield
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        indicatorWheel.startAnimating()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Network connection is available")
            } else {
                print("No network connection")
            }
        }
        monitor.start(queue: queue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchDestinationPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/1.5
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func suggestTripName() {
        guard let cityName = city else { return }
        if inUSA == true {
            if let stateName = state {
                tripNameTextField.text = "\(cityName), \(stateName)"
            }
            
        } else {
            if let countryName = country {
                tripNameTextField.text = "\(cityName), \(countryName)"
            }
        }
    }
    
    @IBAction func createTripButtonTapped(_ sender: Any) {
            
        guard let city = city,
            let dateOfTrip = dateOfTrip,
            let daysInt = durationInDays,
            let isUSA = inUSA else {
                presentUIHelperAlert(title: "Missing Details", message: "Please go back, and enter all trip details")
                return
        }
    
        guard let tripName = tripNameTextField.text, !tripName.isEmpty else {
            self.presentUIHelperAlert(title: "Missing Trip Name", message: "Please enter a trip name, occasion to continue")
            return
        }
        
        // check for usa and abroad
        if isUSA == true {
            // add helper UI pop up
            guard let stateName = state else { return }
            let stateCode = TripController.shared.fetchStateCode(stateFullName: stateName)
            if !stateCode.isEmpty {
                TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: "US", destinationCountryName: "United States", destinationCurrencyCode: "USD", destinationStateCode: stateCode, inUSA: true, name:
                    tripName, durationInDays: daysInt)
                print("Trip for USA was created")
            } else {
                presentUIHelperAlert(title: "Invalid State", message: "Please go back, and enter a valid state")
                return
            }
        
        } else {
            // add helper UI pop up
            guard let countryName = country else { return }
            let destCountryCode = TripController.shared.fetchCountryCode(countryFullName: countryName)
            let destCurrencyCode = TripController.shared.fetchCountryCurrencyCode(isoCountryCode: destCountryCode)
            if !destCountryCode.isEmpty {
                TripController.shared.createTripWith(date: dateOfTrip, destinationCity: city, destinationCountryCode: destCountryCode, destinationCountryName: countryName, destinationCurrencyCode: destCurrencyCode, destinationStateCode: nil, inUSA: false, name: tripName, durationInDays: daysInt)
                print("Trip for abroad was created")
            } else {
                presentUIHelperAlert(title: "Invalid Country", message: "Please go back, and enter a valid country")
                return
            }
        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
                
            case .authorized, .provisional:
                if isUSA == true {
                    self.scheduleNotification(notificationTitle: "Upcoming Trip Tomorrow", notificationBody: "Don't forget to pack ID, phone charger, & toothbrush", tripDate: dateOfTrip)
                } else {
                    self.scheduleNotification(notificationTitle: "Upcoming Trip Tomorrow", notificationBody: "Don't forget to pack passport, phone charger, & toothbrush", tripDate: dateOfTrip)
                }
                print("user allowed notifications and they were scheduled")
            case .denied:
                print("User denied notifications")
            case .notDetermined:
                print("Notifications not determined by user")
            default:
                print("Notifcation Defualt case")
                
            }
        }
        
        showMainTripListViewController()
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CreateTripPart2ViewController.self) {
                self.navigationController?.popViewController(animated: true)
                print("Finalize VC popped to CreateTripPart2")
                break
            }
        }
    }
    
    func fetchDestinationPhoto() {
        // make api call to get a randomn image
        if self.monitor.currentPath.status == .satisfied {
            if inUSA == true {
                       // need state code
                       if let stateName = state, !stateName.isEmpty {
                           let stateCode = TripController.shared.fetchStateCode(stateFullName: stateName)
                           if !stateCode.isEmpty {
                               DestinationInfoController.shared.fetchStateDestinationInfo(stateCode: stateCode) { (destinationResults) in
                                   if let destinationInfoFetched = destinationResults {
                                       self.destinationResults = destinationInfoFetched
                                       // display the image view
                                       let singleResult = self.destinationResults.randomElement()?.images[0]
                                       if let finalImage = singleResult {
                                           DestinationInfoController.shared.fetchDestinationImage(imageURL: finalImage.sizes.medium) { (foundImage) in
                                               if let newImage = foundImage {
                                                   DispatchQueue.main.async {
                                                       self.indicatorWheel.stopAnimating()
                                                       self.destinationPhoto.image = newImage
                                                       self.destinationPhoto.addCornerRadius(17)
                                                       self.destinationPhoto.addBorder()
                                                   }
                                               } else {
                                                   DispatchQueue.main.async {
                                                       self.indicatorWheel.stopAnimating()
                                                   }
                                               }
                                           }
                                       } else {
                                           DispatchQueue.main.async {
                                               self.indicatorWheel.stopAnimating()
                                           }
                                       }
                                   } else {
                                       // show default image
                                       DispatchQueue.main.async {
                                           self.indicatorWheel.stopAnimating()
                                       }
                                   }
                               } // end of API call
                           } else {
                               indicatorWheel.stopAnimating()
                               presentUIHelperAlert(title: "Invalid State", message: "Please go back, and enter a valid state")
                           }
                       } else {
                           DispatchQueue.main.async {
                               self.indicatorWheel.stopAnimating()
                           }
                       }// end of state search
                   // abroad api call
                   } else {
                       // need country code
                       if let countryName = country, !countryName.isEmpty {
                           let countryCode = TripController.shared.fetchCountryCode(countryFullName: countryName)
                           if !countryCode.isEmpty {
                               DestinationInfoController.shared.fetchCountryDestinationInfo(countryCode: countryCode) { (abroadResults) in
                                   if let abroadDestinationResults = abroadResults {
                                       self.destinationResults = abroadDestinationResults
                                       let singleResult = self.destinationResults.randomElement()?.images[0]
                                       //let image = singleResult?.images[0]
                                       if let finalImage = singleResult {
                                           DestinationInfoController.shared.fetchDestinationImage(imageURL: finalImage.sizes.medium) { (foundImage) in
                                               if let newImage = foundImage {
                                                   DispatchQueue.main.async {
                                                       self.indicatorWheel.stopAnimating()
                                                       self.destinationPhoto.image = newImage
                                                       self.destinationPhoto.addCornerRadius(17)
                                                       self.destinationPhoto.addBorder()
                                                   }
                                               } else {
                                                   DispatchQueue.main.async {
                                                       self.indicatorWheel.stopAnimating()
                                                   }
                                               }
                                           }
                                       } else {
                                           DispatchQueue.main.async {
                                               self.indicatorWheel.stopAnimating()
                                           }
                                       }
                                   } else {
                                       DispatchQueue.main.async {
                                           self.indicatorWheel.stopAnimating()
                                       }
                                   }
                                   
                               }
                               
                           } else {
                               indicatorWheel.stopAnimating()
                               presentUIHelperAlert(title: "Invalid Country", message: "Please go back, and enter a valid country")
                           }
                          
                       } else {
                           DispatchQueue.main.async {
                               self.indicatorWheel.stopAnimating()
                           }
                       }
                   }
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.indicatorWheel.stopAnimating()
            self.presentUIHelperAlert(title: "No Connectivity", message: "Please enable internet connectivity on your device.")
        }
    }
    
    func scheduleNotification(notificationTitle: String, notificationBody: String, tripDate: Date) {
          let content = UNMutableNotificationContent()
          content.title = notificationTitle
          content.body = notificationBody
          content.sound = .default
          
          if let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: tripDate) {
              
              var triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .second], from: triggerDate)
              triggerDateComponents.hour = 8
              triggerDateComponents.minute = 00
              let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
              
              
              let request = UNNotificationRequest(identifier: "1dayBeforeTrip", content: content, trigger: notificationTrigger)
              
              UNUserNotificationCenter.current().add(request) { (_) in
                  print("Notification request executed")
              }
          
          }
      }
    
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }

    func showMainTripListViewController() {
        let storyboard = UIStoryboard(name: "Trip", bundle: nil)
        guard let mainTripListViewController = storyboard.instantiateViewController(withIdentifier: "TripViewController") as? TripViewController else { return }
        self.navigationController?.pushViewController(mainTripListViewController, animated: true)
    }
    
    func navigateToMainTabBar() {
        
    }
}

extension FinalizeTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FinalizeTripViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FinalizeTripViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
