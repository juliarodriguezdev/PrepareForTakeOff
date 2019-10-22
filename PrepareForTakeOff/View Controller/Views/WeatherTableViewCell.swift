//
//  WeatherTableViewCell.swift
//  PrepareForTakeOff
//
//  Created by Julia Rodriguez on 10/16/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    var weatherItem: WeatherDetails?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var sealevelLabel: UILabel!
    
    @IBOutlet weak var groundlevelLabel: UILabel!
    
    @IBOutlet weak var windspeedLabel: UILabel!
    
    @IBOutlet weak var windDegreesLabel: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let weatherDisplay = weatherItem else { return }
        dateLabel.text = weatherDisplay.timestampOfForecast
        // weather == [Weather] - custom data type
        let weatherFromArray = (weatherDisplay.weather).first
        mainLabel.text = weatherFromArray?.main
        descriptionLabel.text = weatherFromArray?.description
        if let iconName = weatherFromArray?.icon {
            icon.image = UIImage(named: iconName)
        }
        temperatureLabel.text = "Temperature: \(weatherDisplay.main.temp)"
        pressureLabel.text = "Pressure: \(weatherDisplay.main.pressure)"
        humidityLabel.text = "Humidity: \(weatherDisplay.main.humidity)"
        sealevelLabel.text = "Sea Level: \(weatherDisplay.main.seaLevel)"
        groundlevelLabel.text = "Ground Level: \(weatherDisplay.main.groundLevel)"
        windspeedLabel.text = "Wind Speed: \(weatherDisplay.wind.speed)"
        windDegreesLabel.text = "Wind Degrees: \(weatherDisplay.wind.deg)"
        
    }
}
