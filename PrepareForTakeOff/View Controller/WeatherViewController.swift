//
//  WeatherViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    var weatherResults: [WeatherDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        fetchWeatherResults()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeatherResults()
    }
    
    func fetchWeatherResults() {
       guard let trip = TripController.shared.tripForAllTabs else { return }
    
       let cityID = TripController.shared.fetchCityIDNumber(trip: trip)
        print("The city ID is: \(cityID)")
        if cityID != "" {
            WeatherController.shared.fetch5DayCityIDWeatherForecast(cityID: cityID) { (weatherDetails) in
                if let weatherDetailsFetched = weatherDetails {
                    self.weatherResults = weatherDetailsFetched
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadData()
                    }
                }
            }
         // no cityID found
        } else if cityID == ""{
            if var city = trip.destinationCity, let countryCode = trip.destinationCountryCode {
                WeatherController.shared.fetch5DayCityCountryCodeForecast(city: city, countryCode: countryCode) { (cityCountryWeatherDetails) in
                    if let weatherFetched = cityCountryWeatherDetails {
                        self.weatherResults = weatherFetched
                        DispatchQueue.main.async {
                            self.weatherTableView.reloadData()
                        }
                    } else {
                        // append county
                        city.append(" county")
                        print("City and County String is: \(city)")
                        WeatherController.shared.fetch5DayCityCountryCodeForecast(city: city, countryCode: countryCode) { (cityCountyResults) in
                            if let cityCountryFetched = cityCountyResults {
                                self.weatherResults = cityCountryFetched
                                DispatchQueue.main.async {
                                    self.weatherTableView.reloadData()
                                }
                            }
                        }
                    }
                }
                
            } // end of cityID = ""
        }
    }

}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell()}
        let weatherItem = weatherResults[indexPath.row]
        // send object
        cell.weatherItem = weatherItem
        // call update views
        cell.updateViews()
        return cell
    }
    
    
}