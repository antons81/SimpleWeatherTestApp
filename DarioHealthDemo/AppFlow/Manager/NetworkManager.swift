//
//  NetworkManager.swift
//  DarioHealthDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import UIKit


final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func LoadCurrentWeather<T: Decodable>(model: T.Type, url: String,
                                          completion: ((T) -> Void)?,
                                          errorCompletion: ((Error?) -> Void)?) {

        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/weather"
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: url),
            URLQueryItem(name: "appid", value: "0cd74bf29e43ef1ad6afd6861cc99eb2")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(model, from: data) {
                    completion?(response)
                    return
                }
            }
            errorCompletion?(error)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
    
    func LoadWeatherList<T: Decodable>(model: T.Type, lon: Double,
                                       lat: Double,
                                       completion: ((T) -> Void)?,
                                       errorCompletion: ((Error?) -> Void)?) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.openweathermap.org"
        urlComponent.path = "/data/2.5/forecast"
        urlComponent.queryItems = [
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "appid", value: "0cd74bf29e43ef1ad6afd6861cc99eb2")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(model, from: data, keyPath: "list") {
                    completion?(response)
                    return
                }
            }
            errorCompletion?(error)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
}
