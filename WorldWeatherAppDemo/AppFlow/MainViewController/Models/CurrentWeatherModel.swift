//
//  Models.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let main: Main?
    let sys: Sys?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case main = "main"
        case sys = "sys"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coord = try? container.decode(Coord.self, forKey: .coord)
        self.weather = try? container.decode([Weather].self, forKey: .weather)
        self.main = try? container.decode(Main.self, forKey: .main)
        self.sys = try? container.decode(Sys.self, forKey: .sys)
        self.name = try? container.decode(String.self, forKey: .name)
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon: Double?
    let lat: Double?

    enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lon = try? container.decode(Double.self, forKey: .lon)
        self.lat = try? container.decode(Double.self, forKey: .lat)
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try? container.decode(Double.self, forKey: .temp)
        self.feelsLike = try? container.decode(Double.self, forKey: .feelsLike)
        self.tempMin = try? container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try? container.decode(Double.self, forKey: .tempMax)
        self.pressure = try? container.decode(Int.self, forKey: .pressure)
        self.humidity = try? container.decode(Int.self, forKey: .humidity)
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int64
    let sunset: Int64

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}
