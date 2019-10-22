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
    var groupedWeatherResults : [String: [WeatherDetails]]?
    var sectionTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        fetchWeatherResults()
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
                    self.createDictionaryByDate(weatherResults: self.weatherResults)
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
                        self.createDictionaryByDate(weatherResults: self.weatherResults)
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
                                self.createDictionaryByDate(weatherResults: self.weatherResults)
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
    func createDictionaryByDate(weatherResults: [WeatherDetails]) {
        //let sourceArray = [[]]
        //let dateConverstion = weatherResults.map({$0.timestampOfForecast.convertToDate()})
        let grouped = Dictionary(grouping: weatherResults, by: { String($0.timestampOfForecast.prefix(10)) })
        // test = dateConverstion.filter({$0.compare(Date)})
        print(grouped)
        self.groupedWeatherResults = grouped
        self.sectionTitles = groupedWeatherResults?.keys.sorted() ?? []
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionTitles.count > section {
            return sectionTitles[section]
        } else {
            return "Empty"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let groupedWeather = groupedWeatherResults else { return 0 }
        
        let keyNames = groupedWeather.map({$0.key})
        return keyNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groupedWeather = groupedWeatherResults,
            sectionTitles.count > section else { return 0 }
        let values = groupedWeather[sectionTitles[section]]
        return values?.count ?? 0
        //return weatherResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell()}
        
        let sectionTitle = sectionTitles[indexPath.section]
        // dictionary then to array
        let weatherItem = groupedWeatherResults?[sectionTitle]?[indexPath.row]
        
        // send object
        cell.weatherItem = weatherItem
        // call update views
        cell.updateViews()
        return cell
    }
    
    
}
