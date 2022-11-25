//
//  MainViewModel.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 24.07.2022.
//

import Foundation
import KRProgressHUD

final class WeatherViewModel: NSObject {
    
    // MARK: - Observers
    var weathers: ObservableObject<[CurrentWeather]> = ObservableObject(nil)
    var currentWeather: ObservableObject<CurrentWeather> = ObservableObject(nil)
    var isImperial: ObservableObject<Bool> = ObservableObject(nil)
    
    // MARK: - Private variables
    private var group = DispatchGroup()
    private var data = [CurrentWeather]()
    private var tempWeathers = [CurrentWeather]()
    
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
            self.tempWeathers = self.weathers.value ?? [CurrentWeather]()
            KRProgressHUD.dismiss()
        }
    }
}

extension WeatherViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as WeatherCell
        return cell
    }
}

extension WeatherViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WeatherCell, let values = self.weathers.value {
            let weather = values[indexPath.row]
            let isImperial = UserDefaults.isImperial
            cell.setupCell(weather, isImperial: isImperial)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let values = self.weathers.value else { return }
        let currentWeather = values[indexPath.row]
        self.currentWeather.value = currentWeather
    }
}

extension WeatherViewModel: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.weathers.value = self.tempWeathers
            return
        }
        
        let newData = self.weathers.value?.filter { $0.name?.contains(searchText) ?? false }
        self.weathers.value = newData
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.weathers.value = self.tempWeathers
    }
}
