//
//  DailyWeatherViewModel.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 25.07.2022.
//

import Foundation
import KRProgressHUD

typealias WeatherList = [ListWeatherModel]

final class DailyWeatherViewModel {
    
    // MARK: - Observers
    var weathers: ObservableObject<WeatherList> = ObservableObject(nil)

    func composeWeather(_ lon: Double, _ lat: Double) {
        KRProgressHUD.showProgress()
        NetworkManager.shared.loadWeatherList(model: WeatherList.self,
                                              lon: lon,
                                              lat: lat) { [weak self] weathers in
            self?.weathers.value = weathers
        } errorCompletion: { _ in
            self.weathers.value = nil
        }
    }
}
