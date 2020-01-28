//
//  WeatherViewController.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit
import Network

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    // make landing pad from first fetch
    var weatherResults: [WeatherDetails] = []
    var groupedWeatherResults : [String: [WeatherDetails]]?
    var sectionTitles: [String] = []
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "WeatherMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.travelBackground
        self.weatherTableView.backgroundColor = UIColor.travelBackground
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        if let trip = TripController.shared.tripForAllTabs {
            nameLabel.text = trip.name
        }
        fetchWeatherResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        fetchWeatherResults()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        monitor.cancel()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchWeatherResults() {
        guard let trip = TripController.shared.tripForAllTabs else { return }
        let cityID = TripController.shared.fetchCityIDNumber(trip: trip)
        print("The city ID is: \(cityID)")
        
        if self.monitor.currentPath.status == .satisfied {
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
            
        } else if self.monitor.currentPath.status == .unsatisfied {
            self.presentUIHelperAlert(title: "No Connectivity", message: "Please enable internet connectivity on your device.")
        }
        
    } // end fetchWeatherResults()
    
    func createDictionaryByDate(weatherResults: [WeatherDetails]) {
        //let sourceArray = [[]]
        //let dateConverstion = weatherResults.map({$0.timestampOfForecast.convertToDate()})
        let grouped = Dictionary(grouping: weatherResults, by: { String($0.timestampOfForecast.prefix(10)) })
        // test = dateConverstion.filter({$0.compare(Date)})
        print(grouped)
        self.groupedWeatherResults = grouped
        self.sectionTitles = groupedWeatherResults?.keys.sorted() ?? []
    }
    
    func updateWeatherDescription() {
        guard let tripDate = TripController.shared.tripForAllTabs?.date else { return }
        let today = Date()
        let components = Calendar.current.dateComponents([.day], from: today, to: tripDate)
        
        if let projectedWeather = Calendar.current.date(byAdding: .day, value: 5, to: today)?.convertToDescription() {
            if let countdown = components.day {
                let weatherAvailable = countdown - 5
                
                if countdown <= 5 {
                    weatherDescriptionLabel.text = "Weather displayed from today to \(projectedWeather)"
                } else if countdown > 5 {
                    weatherDescriptionLabel.text = "Weather displayed from today to \(projectedWeather) \n\nCheck back in \(weatherAvailable) days \nfor weather update during your trip"
                }
            }
        }
    }
    func presentUIHelperAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // ui label inherits from ui view
        let header = UIView()
        let frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width) * 0.95, height: 50)
        let myCustomView = UIImageView(frame: frame)
        let rippedPaperImage: UIImage = UIImage(named: "95300299-torn-paper-ribbons-with-jagged-edges-abstract-grange-paper-sheets-vector-set-ripped-paper-design-ban")!
        myCustomView.image = rippedPaperImage
        myCustomView.contentMode = .scaleToFill
        
        header.addSubview(myCustomView)
        let frameLabel = CGRect(x: 0, y: 0, width: (self.view.frame.size.width) * 0.90, height: 50)
        let dateLabel = UILabel(frame: frameLabel)
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: FontNames.fingerPaintRegular, size: 18)
        dateLabel.textAlignment = .center
    
         if sectionTitles.count > section {
            dateLabel.text = sectionTitles[section].convertToHeaderString()
               } else {
            dateLabel.text = "No Weather to Display"
               }
        header.addSubview(dateLabel)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groupedWeather = groupedWeatherResults,
            sectionTitles.count > section else { return 0 }
        // example: value = groupedWeather[10-24-2019]
        let values = groupedWeather[sectionTitles[section]]
        return values?.count ?? 0
        //return weatherResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell()}
        cell.backgroundColor = UIColor.travelBackground
        cell.selectionStyle = .none
        
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
