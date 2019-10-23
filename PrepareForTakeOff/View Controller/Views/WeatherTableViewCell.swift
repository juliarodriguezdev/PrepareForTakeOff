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
        
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
        
    @IBOutlet weak var groundlevelLabel: UILabel!
    
    @IBOutlet weak var windspeedLabel: UILabel!
        
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let weatherDisplay = weatherItem else { return }
        dateLabel.text = weatherDisplay.timestampOfForecast.convertToRowTitle()
        // weather == [Weather] - custom data type
        let weatherFromArray = (weatherDisplay.weather).first
        descriptionLabel.text = weatherFromArray?.description.capitalizingFirstletter()
        if let iconName = weatherFromArray?.icon {
            icon.image = UIImage(named: iconName)
        }
        
        func pressureinHG(pressure: Double) -> String {
            let newValue = pressure / 33.863886666667
            let stringinHG = String(format: "%.2f", newValue) + " inHG"
            return stringinHG
            
        }
        let pressureText = pressureinHG(pressure: weatherDisplay.main.pressure)
        pressureLabel.text = "Pressure @ Sea: " + pressureText
        
        let groundLevelText = pressureinHG(pressure: weatherDisplay.main.groundLevel)
        groundlevelLabel.text = "Pressure @ Ground: " + groundLevelText
        
        temperatureLabel.text = "Temperature: \(weatherDisplay.main.temp) ºF"
        humidityLabel.text = "Humidity: \(weatherDisplay.main.humidity) %"
        
        
        var windDegText : String = ""
        
        switch weatherDisplay.wind.deg {
        
        case 0...11.24:
            windDegText = "N"
        case 11.25...33.75:
            windDegText = "NNE"
        case 33.75...56.25:
            windDegText = "NE"
        case 56.25...78.75:
            windDegText = "ENE"
        case 78.75...101.25:
            windDegText = "E"
        case 101.25...123.75:
            windDegText = "ESE"
        case 123.75...146.25:
            windDegText = "SE"
        case 146.25...168.75:
            windDegText = "SSE"
        case 168.75...191.25:
            windDegText = "S"
        case 191.25...213.75:
            windDegText = "SSW"
        case 213.75...236.25:
            windDegText = "SW"
        case 236.25...258.75:
            windDegText = "WSW"
        case 258.75...281.25:
            windDegText = "W"
        case 281.25...303.75:
            windDegText = "WNW"
        case 303.75...326.25:
            windDegText = "NW"
        case 326.25...348.75:
            windDegText = "NNW"
        case 348.76...360:
            windDegText = "N"
        default:
            print("No wind direction detected")
        }
        windspeedLabel.text = "Wind: " + windDegText + " \(weatherDisplay.wind.speed) mph"
       
    }
}
