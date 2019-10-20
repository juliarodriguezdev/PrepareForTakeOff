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
        temperatureLabel.text = "\(weatherDisplay.main.temp)"
        pressureLabel.text = "\(weatherDisplay.main.pressure)"
        humidityLabel.text = "\(weatherDisplay.main.humidity)"
        sealevelLabel.text = "\(weatherDisplay.main.seaLevel)"
        groundlevelLabel.text = "\(weatherDisplay.main.groundLevel)"
        windspeedLabel.text = "\(weatherDisplay.wind.speed)"
        windDegreesLabel.text = "\(weatherDisplay.wind.deg)"
        
    }
}
