//
//  MainViewController.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 02/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties Section
    
    var backgroundView: BackgroundView?
    let spc = SearchPopupController()
    var generalData: EightDayForecastData?
    var detailData: ThreeHoursForecastData?

    var tableView: UITableView = {
       let tblv = UITableView()
        tblv.backgroundColor = UIColor.clear
        tblv.translatesAutoresizingMaskIntoConstraints = false
        tblv.rowHeight = 125
        tblv.separatorStyle = .none
        return tblv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView = BackgroundView(frame: view.frame, imageName: "background", color: Constants.backgroundColor)
        view.addSubview(backgroundView!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchPopup))
        navigationItem.title = "FutuWeather"

        setupTableView()
        spc.delegate = self
    }
    
    // MARK: - Functionality Section
    
    @objc func showSearchPopup() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = 0
        }) { (complete) in
            if complete {
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.addChild(self.spc)
                self.view.addSubview(self.spc.view)
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainViewCell.self, forCellReuseIdentifier: "\(MainViewCell.self)")
    }

}

// MARK: - Delegates Section

extension MainViewController: UpdateViewWithData {
    func updateMainView(withData: Bool) {
        if withData {
            guard let data = detailData else { return }
            self.navigationItem.title = "\(data.city.name) \(CountryRepresentationConverter.getFlag(fromCountry: data.city.country))"
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if withData {
            reload()
        } else {
            showOld()
        }
    }
    
    private func showOld() {
        UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 1
        }
    }
    
    private func reload() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.reloadData()
        }) { (complete) in
            if complete {
                self.tableView.alpha = 1
            }
        }
    }
}
    
extension MainViewController: UpdateControllerWithData {
    
    func updateController(withGeneralData data: EightDayForecastData) {
        generalData = data
    }
    
    func updateController(withDetailData data: ThreeHoursForecastData) {
        detailData = data
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = generalData else { return 0 }
        let days = data.daily.dropLast(2)
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MainViewCell.self)", for: indexPath) as! MainViewCell
        
        guard let data = generalData else { return cell }
        
        let cellSize = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.rowHeight)
        cell.container.backgroundColor = GradientColorMaker.colorWithGradient(frame: cellSize, colors: Constants.cellColor, direction: .Down)
        
        let day = data.daily[indexPath.row]
        
        cell.dayLabel.text = DateConverter.convertToDay(forTimeZoneWithOffset: data.timezoneOffset, fromUnixTime: day.dt)
        cell.monthLabel.text = DateConverter.convertToMonth(forTimeZoneWithOffset: data.timezoneOffset, fromUnixTime: day.dt)
        cell.tempLabel.text = "\(Int((day.temp.day).rounded()))°C"
        cell.icon.image = WeatherConditionConverter.prepareIcon(forWeatherCondition: day.weather[0].id)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = generalData else { return }
        guard let specificData = detailData else { return }
        
        let day = data.daily[indexPath.row]
        
        let dvc = DetailViewController()
        dvc.timeOffset = data.timezoneOffset
        dvc.dailyData = day
        dvc.hourlyData = specificData.list.filter({
            let date = ISOTimeConverter.getFullDate(offset: specificData.city.timezone, unix: $0.dt)
            return date == ISOTimeConverter.getFullDate(offset: data.timezoneOffset, unix: day.dt)
        })
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
        }
    }
    
}

