//
//  DailyWeatherViewModel.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 25.07.2022.
//

import Foundation
import KRProgressHUD

typealias WeatherList = [ListWeatherModel]

final class DailyWeatherViewModel: NSObject {
    
    // MARK: - Observers
    var weathers: ObservableObject<WeatherList> = ObservableObject(nil)
    var singleDay: ObservableObject<ListWeatherModel> = ObservableObject(nil)
    
    private var currentWeathers = WeatherList() {
        didSet {
            let newData = Dictionary(grouping: self.currentWeathers,
                                     by: { Date(timeIntervalSince1970: TimeInterval($0.dt ?? 0))
                .dateToString(with: "yyyy-MM-dd") })
            
            self.currentWeathers.removeAll()
            for (_ , value) in newData {
                if let value = value.first {
                    self.currentWeathers.append(value)
                }
            }
            
            self.currentWeathers = self.currentWeathers.sorted {
                Date(timeIntervalSince1970: TimeInterval($0.dt ?? 0)).compare(Date(timeIntervalSince1970: TimeInterval($1.dt ?? 0))) == .orderedAscending
            }
            
            self.currentWeathers = Array(self.currentWeathers.dropFirst())
            self.weathers.value = self.currentWeathers
        }
    }

    func composeWeather(_ lon: Double, _ lat: Double) {
        KRProgressHUD.showProgress()
        NetworkManager.shared.loadWeatherList(model: WeatherList.self,
                                              lon: lon,
                                              lat: lat) { [weak self] weathers in
            self?.currentWeathers = weathers
            self?.singleDay.value = weathers.first
        } errorCompletion: { _ in
            self.weathers.value = nil
        }
    }
}


extension DailyWeatherViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as WeatherCell
        return cell
    }
}

extension DailyWeatherViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WeatherCell, let weathers = self.weathers.value {
            let weather = weathers[indexPath.row]
            let isImperial = UserDefaults.isImperial
            cell.setupCurrentWeather(weather, isImperial: isImperial)
        }
    }
}
