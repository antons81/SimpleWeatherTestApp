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
            mainThread {
                self?.tableView.reloadData()
                KRProgressHUD.dismiss()
            }
        }
        
        viewModel.singleDay.bind { singleDay in
            self.singleWeather = singleDay
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
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        self.name.text = self.cityName
        self.title = self.cityName
    }
    
    
}
