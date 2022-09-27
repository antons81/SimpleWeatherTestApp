//
//  NetworkManager.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import UIKit

enum EndPoints {
    case weather
    case forecast
}

extension EndPoints {
    var endPoint: String {
        switch self {
        case .weather: return "/data/2.5/weather"
        case .forecast: return "/data/2.5/forecast"
        }
    }
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    static private let host = "api.openweathermap.org"
    
    private func runTask<T: Decodable>(with request: URLRequest,
                                       model: T.Type,
                                       key: String? = nil,
                                       completion: ((T) -> Void)?,
                                       errorCompletion: ((Error?) -> Void)?) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if key == nil {
                    if let response = try? JSONDecoder().decode(model, from: data) {
                        completion?(response)
                        return
                    }
                } else {
                    if let response = try? JSONDecoder().decode(model, from: data, keyPath: key ?? "") {
                        completion?(response)
                        return
                    }
                }
            }
            errorCompletion?(error)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
    
    func loadCurrentWeather<T: Decodable>(model: T.Type, url: String,
                                          completion: ((T) -> Void)?,
                                          errorCompletion: ((Error?) -> Void)?) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = NetworkManager.host
        urlComponent.path = EndPoints.weather.endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: url),
            URLQueryItem(name: "appid", value: "0cd74bf29e43ef1ad6afd6861cc99eb2")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        runTask(with: request, model: model) { response in
            completion?(response)
        } errorCompletion: { error in
            errorCompletion?(error)
        }
    }
    
    func loadWeatherList<T: Decodable>(model: T.Type,
                                       lon: Double,
                                       lat: Double,
                                       completion: ((T) -> Void)?,
                                       errorCompletion: ((Error?) -> Void)?) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = NetworkManager.host
        urlComponent.path = EndPoints.forecast.endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "lon", value: lon.toString),
            URLQueryItem(name: "lat", value: lat.toString),
            URLQueryItem(name: "appid", value: "0cd74bf29e43ef1ad6afd6861cc99eb2")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        runTask(with: request, model: model, key: "list") { response in
            completion?(response)
        } errorCompletion: { error in
            errorCompletion?(error)
        }
    }
}
