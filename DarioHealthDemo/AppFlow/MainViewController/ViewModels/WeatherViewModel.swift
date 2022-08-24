//
//  MainViewModel.swift
//  DarioHealthDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import Foundation
import KRProgressHUD

final class WeatherViewModel {
    
    // MARK: - Observers
    var weathers: ObservableObject<[CurrentWeather]> = ObservableObject(nil)
    var isImperial: ObservableObject<Bool> = ObservableObject(nil)
    
    // MARK: - Private variables
    private var group = DispatchGroup()
    private var data = [CurrentWeather]()
    
    func upsateMetric(_ value: Bool) {
        isImperial.value = value
    }
    
    func composeWeather(_ cities: [String]) {
        
        KRProgressHUD.showProgress()
        data.removeAll()
        
        for city in cities {
            group.enter()
            NetworkManager.shared.loadCurrentWeather(model: CurrentWeather.self,
                                                     url: city) { [weak self] weather in
                self?.data.append(weather)
                self?.group.leave()
            } errorCompletion: { error in
                self.weathers.value = nil
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.weathers.value = self.data
            KRProgressHUD.dismiss()
        }
    }
}
