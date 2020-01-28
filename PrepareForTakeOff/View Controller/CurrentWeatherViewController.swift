//
//  CurrentWeatherViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 12/19/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class CurrentWeatherViewController: UIViewController {

    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var previewWeatherCollectionView: UICollectionView!
    @IBOutlet weak var noWeatherResultsLabel: UILabel!
    @IBOutlet weak var moreDetailsBackground: UIImageView!
    @IBOutlet weak var moreDetailButton: UIButton!
    @IBOutlet weak var temperatureConstraint: NSLayoutConstraint!
    
    var weatherResults: [WeatherDetails] = []
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "CurrentWeatherMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        previewWeatherCollectionView.backgroundColor = .clear
        previewWeatherCollectionView.delegate = self
        previewWeatherCollectionView.dataSource = self
        moreDetailButton.setTitle("     More Details", for: .normal)
        if let trip = TripController.shared.tripForAllTabs {
            nameLabel.text = trip.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let trip = TripController.shared.tripForAllTabs {
            nameLabel.text = trip.name
        }
        moreDetailsBackground.isHidden = true
        moreDetailButton.isHidden = true
        noWeatherResultsLabel.isHidden = true
        noWeatherResultsLabel.text = "Weather could not be retrieved"
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Network connection is available")
            } else {
                print("No network connection ")
            }
        }
        monitor.start(queue: queue)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.fetchWeatherResults()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
        currentIcon.image = nil
        nameLabel.text = ""
        temperatureLabel.text = ""
        noWeatherResultsLabel.isHidden = true
        
    }
    
    @IBAction func moreDetailsButtonTapped(_ sender: Any) {
        // push more details View Controller
        showMoreDetailsViewController()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showMoreDetailsViewController() {
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        guard let moreDetailsVC = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController else { return }
        self.navigationController?.pushViewController(moreDetailsVC, animated: true)
    }
    
    func fetchWeatherResults() {
        
        guard let trip = TripController.shared.tripForAllTabs else { return }
        let cityID = TripController.shared.fetchCityIDNumber(trip: trip)
        
        if self.monitor.currentPath.status == .satisfied {
            if !cityID.isEmpty {
                WeatherController.shared.fetch5DayCityIDWeatherForecast(cityID: cityID) { (weatherDetails) in
                    if let weatherDetailsFetched = weatherDetails {
                        self.weatherResults = weatherDetailsFetched
                        DispatchQueue.main.async {
                            // update icon image & temperature label
                            self.updateCurrentWeatherDisplay()
                            self.previewWeatherCollectionView.reloadData()
                            self.moreDetailsBackground.isHidden = false
                            self.moreDetailButton.isHidden = false
                            self.temperatureConstraint.constant = -15
                            self.temperatureLabel.font = self.temperatureLabel.font.withSize(60)
                        }
                    } else {
                        // say no results found
                        DispatchQueue.main.async {
                            self.showNoWeatherFound(resultText: "No Results")
                        }
                    }
                }
                // no cityID found
            } else if cityID.isEmpty {
                if var city = trip.destinationCity, let countryCode = trip.destinationCountryCode {
                    WeatherController.shared.fetch5DayCityCountryCodeForecast(city: city, countryCode: countryCode) { (cityCountryWeatherDetails) in
                        if let weatherFetched = cityCountryWeatherDetails {
                            self.weatherResults = weatherFetched
                            DispatchQueue.main.async {
                                self.updateCurrentWeatherDisplay()
                                self.previewWeatherCollectionView.reloadData()
                                self.moreDetailsBackground.isHidden = false
                                self.moreDetailButton.isHidden = false
                                self.temperatureConstraint.constant = -15
                                self.temperatureLabel.font = self.temperatureLabel.font.withSize(60)
                            }
                        } else {
                            // append county to search
                            city.append(" county")
                            print("City with County search is: \(city)")
                            WeatherController.shared.fetch5DayCityCountryCodeForecast(city: city, countryCode: countryCode) { (cityCountyResults) in
                                if let cityCountyFetched = cityCountyResults {
                                    self.weatherResults = cityCountyFetched
                                    DispatchQueue.main.async {
                                        self.updateCurrentWeatherDisplay()
                                        self.previewWeatherCollectionView.reloadData()
                                        self.moreDetailsBackground.isHidden = false
                                        self.moreDetailButton.isHidden = false
                                        self.temperatureConstraint.constant = -15
                                        self.temperatureLabel.font = self.temperatureLabel.font.withSize(60)
                                        
                                    }
                                } else {
                                    // show no results
                                    DispatchQueue.main.async {
                                        self.showNoWeatherFound(resultText: "No Results")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.showNoWeatherFound(resultText: "No internet")
        }
        // 1. find most accurate search - CityID
        
    }
    
    func updateCurrentWeatherDisplay() {
        if !weatherResults.isEmpty {
            if let currentWeather = (weatherResults.first)?.weather.first,
                let weatherDetails = weatherResults.first {
                let convertedInteger = Int(weatherDetails.main.temp.rounded())
                currentIcon.image = UIImage(named: currentWeather.icon)
                temperatureLabel.text = "\(convertedInteger)ºF"
            }
                
        } else {
            showNoWeatherFound(resultText: "No Results")
        }
    }
    
    func showNoWeatherFound(resultText: String) {
        currentIcon.image = UIImage(named: "sadCloud")
        temperatureLabel.font = temperatureLabel.font.withSize(22)
        temperatureLabel.text = resultText
        noWeatherResultsLabel.isHidden = false
        temperatureConstraint.constant = 15
    }

}

extension CurrentWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // from .weather we get the .icon (name)
        return weatherResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // reuse identifier: iconCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? CurrentWeatherViewCell else { return UICollectionViewCell()}
        cell.backgroundColor = .clear
        
        let weatherItem = weatherResults[indexPath.row]
        
        if let iconName = weatherItem.weather.first?.icon {
            cell.weatherIcon.image = UIImage(named: iconName)
        }
        cell.weatherIcon.layer.cornerRadius = 25
        cell.weatherIcon.layer.borderWidth = 1
        cell.weatherIcon.clipsToBounds = true
        return cell
    }
    
    
}
