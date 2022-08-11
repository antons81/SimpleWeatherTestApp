//
//  ViewController.swift
//  DarioHealthDemo
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
    private var weathers = [CurrentWeather]() {
        didSet {
            mainThread {
                self.tableView.reloadData()
            }
        }
    }
    private var tempWeathers = [CurrentWeather]()
    
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
        self.tableView.registerCellNib(WeatherCell.self)
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self,
                                 action: #selector(fetchWeather),
                                 for: .valueChanged)
        self.switchButton.isOn = UserDefaults.isImperial
        self.title = "World Weather App"
        
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
            guard let weathers = weathers else {
                mainThread {
                    self?.showErrorAlert()
                    self?.refreshControl.endRefreshing()
                    KRProgressHUD.dismiss()
                }
                return
            }
            self?.weathers = weathers
            self?.tempWeathers = weathers
            self?.refreshControl.endRefreshing()
            KRProgressHUD.dismiss()
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


extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as WeatherCell
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? WeatherCell {
            let weather = self.weathers[indexPath.row]
            let isImperial = UserDefaults.isImperial
            cell.setupCell(weather, isImperial: isImperial)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.weathers[indexPath.row]
        let lon = city.coord?.lon ?? 0
        let lat = city.coord?.lat ?? 0
        
        
        let vc = DailyWeatherViewController(nibName: "DailyWeatherViewController", bundle: nil)
        vc.lat = lat
        vc.lon = lon
        vc.cityName = city.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.weathers = self.tempWeathers
            return
        }
        
        let newData = self.weathers.filter { $0.name?.contains(searchText) ?? false }
        self.weathers = newData
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.weathers = self.tempWeathers
    }
}
