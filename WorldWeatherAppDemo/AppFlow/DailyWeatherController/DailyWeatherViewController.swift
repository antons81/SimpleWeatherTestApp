//
//  DailyWeatheViewController.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 26.07.2022.
//

import UIKit
import KRProgressHUD

final class DailyWeatherViewController: UIViewController {

    // MARK: - Private variables
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var bigIcon: UIImageView!
    @IBOutlet weak private var name: UILabel!
    @IBOutlet weak private var day: UILabel!
    @IBOutlet weak private var desc: UILabel!
    @IBOutlet weak private var min: UILabel!
    @IBOutlet weak private var max: UILabel!
    
    // MARK: - Private variables
    private let viewModel = DailyWeatherViewModel()
    private var weathers = WeatherList() {
        didSet {
            let newData = Dictionary(grouping: self.weathers,
                                     by: { Date(timeIntervalSince1970: TimeInterval($0.dt ?? 0))
                .dateToString(with: "yyyy-MM-dd") })
            
            self.weathers.removeAll()
            for (_ , value) in newData {
                if let value = value.first {
                    self.weathers.append(value)
                }
            }
            
            self.weathers = self.weathers.sorted {
                Date(timeIntervalSince1970: TimeInterval($0.dt ?? 0)).compare(Date(timeIntervalSince1970: TimeInterval($1.dt ?? 0))) == .orderedAscending
            }
            
            self.weathers = Array(self.weathers.dropFirst())
            
            mainThread {
                self.tableView.reloadData()
            }
        }
    }
    
    private var singleWeather: ListWeatherModel? {
        didSet {
            mainThread {
                guard let single = self.singleWeather, let weather = single.weather?.first else { return }
                self.bigIcon.image = UIImage(named: weather.icon ?? "")
                self.day.text = Date(timeIntervalSince1970: TimeInterval(single.dt ?? 0)).dateToString(with: "EEEE").localizedCapitalized
                self.desc.text = weather.weatherDescription
                self.min.text = UserDefaults.isImperial ? single.main?.tempMin.toFahrenheitString : single.main?.tempMin.toCelsiusString
                self.max.text = UserDefaults.isImperial ? single.main?.tempMax.toFahrenheitString : single.main?.tempMax.toCelsiusString
            }
        }
    }
    
    // MARK: - Public variables
    var lat: Double = 0
    var lon: Double = 0
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.binds()
        self.composeData()
    }
}

extension DailyWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as WeatherCell
        return cell
    }
}

extension DailyWeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WeatherCell {
            let weather = self.weathers[indexPath.row]
            let isImperial = UserDefaults.isImperial
            cell.setupCurrentWeather(weather, isImperial: isImperial)
        }
    }
}

extension DailyWeatherViewController {
    
    fileprivate func showErrorAlert() {
        let alert = UIAlertController(title: "Loading error",
                          message: "Cannot parse data at this time",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    fileprivate func binds() {
        viewModel.weathers.bind { [weak self] weathers in
            guard let weathers = weathers else {
                mainThread {
                    self?.showErrorAlert()
                    KRProgressHUD.dismiss()
                }
                return
            }
            
            self?.singleWeather = weathers.first
            self?.weathers = weathers
            KRProgressHUD.dismiss()
        }
    }
    
    fileprivate func composeData() {
        self.viewModel.composeWeather(lon, lat)
    }
    
    fileprivate func setupUI() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.registerCellNib(WeatherCell.self)
        self.name.text = self.cityName
        self.title = self.cityName
    }
}
