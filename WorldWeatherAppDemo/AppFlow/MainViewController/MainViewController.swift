//
//  ViewController.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 23.07.2022.
//

import UIKit
import KRProgressHUD

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var switchButton: UISwitch!
    @IBOutlet weak private var metricLabel: UILabel!
    
    // MARK: - Private variables
    private var refreshControl = UIRefreshControl()
    private let viewModel = WeatherViewModel()
    private let cities = CitiesList.allCases.map { $0.name }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
        self.fetchWeather()
    }
    
    @IBAction func updateMetrics() {
        UserDefaults.isImperial = switchButton.isOn
        viewModel.upsateMetric(switchButton.isOn)
    }
    
    @objc func fetchWeather() {
        viewModel.composeWeather(cities)
    }
}

extension MainViewController {
    
    fileprivate func setupUI() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        
        self.tableView.registerCellNib(WeatherCell.self)
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self,
                                 action: #selector(fetchWeather),
                                 for: .valueChanged)
        self.switchButton.isOn = UserDefaults.isImperial
        self.title = "World Weather App"
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = viewModel
    }
    
    fileprivate func showErrorAlert() {
        let alert = UIAlertController(title: "Loading error",
                          message: "Cannot parse data at this time",
                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    fileprivate func bind() {
        
        self.viewModel.weathers.bind { [weak self] weathers in
            
            mainThread {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                KRProgressHUD.dismiss()
            }
        }
        
        self.viewModel.currentWeather.bind { currentWeather in
            guard let current = currentWeather else { return }
            let dailyVC = DailyWeatherViewController(nibName: "DailyWeatherViewController", bundle: nil)
            dailyVC.lat = current.coord?.lat ?? 0
            dailyVC.lon = current.coord?.lon ?? 0
            dailyVC.cityName = current.name ?? ""
            self.searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(dailyVC, animated: true)
        }
        
        self.viewModel.isImperial.bind { value in
            guard let value = value else { return }
            mainThread {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                self.metricLabel.text = value ? "Imperial" : "Metric"
            }
        }
    }
}
