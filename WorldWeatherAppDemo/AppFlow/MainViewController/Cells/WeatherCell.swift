//
//  WeatherCell.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import UIKit

final class WeatherCell: UITableViewCell, NibReusable {
    
    // MARK: - Outlets
    @IBOutlet weak private var mainLabel: UILabel!
    @IBOutlet weak private var desc: UILabel!
    @IBOutlet weak private var minTemp: UILabel!
    @IBOutlet weak private var maxTemp: UILabel!
    @IBOutlet weak private var icon: UIImageView!
    
    func setupCell(_ data: CurrentWeather, isImperial: Bool) {
        guard let weather = data.weather?.first else { return }
        mainThread {
            self.mainLabel.text = data.name
            self.desc.text = data.weather?.first?.weatherDescription.capitalizingFirstLetter()
            self.minTemp.text = isImperial ? data.main?.tempMin?.toFahrenheitString : data.main?.tempMin?.toCelsiusString
            self.maxTemp.text = isImperial ? data.main?.tempMax?.toFahrenheitString : data.main?.tempMax?.toCelsiusString
            let isNightTime = self.isNightTime(data.sys?.sunrise ?? 0, data.sys?.sunset ?? 0)
            self.icon.image = self.updateWeatherIcon(cond: weather.id, nightTime: isNightTime)
        }
    }
    
    func setupCurrentWeather(_ weatherData: ListWeatherModel, isImperial: Bool) {
        mainThread {
            self.mainLabel.text = Date(timeIntervalSince1970: TimeInterval(weatherData.dt ?? 0)).dateToString(with: "EEEE")
            self.desc.text = weatherData.weather?.first?.weatherDescription?.capitalizingFirstLetter()
            self.minTemp.text = isImperial ? weatherData.main?.tempMin.toFahrenheitString : weatherData.main?.tempMin.toCelsiusString
            self.maxTemp.text = isImperial ? weatherData.main?.tempMax.toFahrenheitString : weatherData.main?.tempMax.toCelsiusString
            self.icon.image = UIImage(named: weatherData.weather?.first?.icon ?? "01d")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.minTemp.text = nil
        self.maxTemp.text = nil
    }
}


extension WeatherCell {
    
    fileprivate func isNightTime(_ sunrise: Int64, _ sunset: Int64) -> Bool {
        var nightTime = false
        let dateNow = Date().timeIntervalSince1970
        let sunrise = TimeInterval(sunrise)
        let sunset = TimeInterval(sunset)
        
        if dateNow < sunrise || dateNow > sunset {
            nightTime = true
        }
        return nightTime
    }
    
    fileprivate func updateWeatherIcon(cond: Int, nightTime: Bool) -> UIImage? {
        
        var imageName: String
        
        switch (cond, nightTime) {
            // Thunderstorm
        case let (x,y) where x < 300 && y == true: imageName = "11n"
        case let (x,y) where x < 300 && y == false: imageName = "11d"
            // Drizzle
        case let (x,y) where x < 500 && y == true: imageName = "09n"
        case let (x,y) where x < 500 && y == false: imageName = "09d"
            // Rain
        case let (x,y) where x <= 504 && y == true: imageName = "10n"
        case let (x,y) where x <= 504 && y == false: imageName = "10d"
            
        case let (x,y) where x == 511 && y == true: imageName = "13n"
        case let (x,y) where x == 511 && y == false: imageName = "13d"
            
        case let (x,y) where x < 600 && y == true: imageName = "09n"
        case let (x,y) where x < 600 && y == false: imageName = "09d"
            // Snow
        case let (x,y) where x < 700 && y == true: imageName = "13n"
        case let (x,y) where x < 700 && y == false: imageName = "13d"
            // Atmosphere
        case let (x,y) where x < 800 && y == true: imageName = "50n"
        case let (x,y) where x < 800 && y == false: imageName = "50d"
            // Clear
        case let (x,y) where x == 800 && y == true: imageName = "01n"
        case let (x,y) where x == 800 && y == false: imageName = "01d"
            // Clouds
        case let (x,y) where x == 801 && y == true: imageName = "02n"
        case let (x,y) where x == 801 && y == false: imageName = "02d"
        case let (x,y) where x == 802 && y == true: imageName = "03n"
        case let (x,y) where x == 802 && y == false: imageName = "03d"
        case let (x,y) where x > 802 && y == true: imageName = "04n"
        case let (x,y) where x > 802 && y == false: imageName = "04d"
            
        case (_, _):
            imageName = ""
        }
        
        let iconImage = UIImage(named: imageName)
        return iconImage
    }
}
