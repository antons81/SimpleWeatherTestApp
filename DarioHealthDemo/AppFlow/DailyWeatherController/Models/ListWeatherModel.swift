//
//  ListWeatherModel.swift
//  DarioHealthDemo
//
//  Created by Anton Stremovskiy on 25.07.2022.
//

import Foundation

struct ListWeatherModel: Codable {
    let dt: Int64?
    let main: MainClass?
    let weather: [ListWeather]?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case dtTxt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try? container.decode(Int64.self, forKey: .dt)
        self.main = try? container.decode(MainClass.self, forKey: .main)
        self.weather = try? container.decode([ListWeather].self, forKey: .weather)
        self.dtTxt = try? container.decode(String.self, forKey: .dtTxt)
    }
}

struct ListWeather: Codable {
    let id: Int
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case weatherDescription = "description"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.weatherDescription = try? container.decode(String.self, forKey: .weatherDescription)
        self.icon = try? container.decode(String.self, forKey: .icon)
    }
}

struct MainClass: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case tempKf = "temp_kf"
    }
}
