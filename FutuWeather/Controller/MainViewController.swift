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
    var popup: SearchPopup?
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
        
        backgroundView = BackgroundView(frame: view.frame, imageName: "background", color: K.backgroundColor)
        view.addSubview(backgroundView!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchPopup))
        navigationItem.title = "FutuWeather"

        setupTableView()
    }
    
    // MARK: - Functionality Section
    
    @objc func showSearchPopup() {
        popup = SearchPopup()
        popup?.delegate = self
        popup?.weatherManager.delegate = self
        let windowKey = UIApplication.shared.windows.first { $0.isKeyWindow }
        windowKey?.addSubview(popup!)
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

extension MainViewController: OutAnimation {
    
    func exitPopup(withData: Bool) {
        popup?.removeFromSuperview()
        guard let data = detailData else { return }
                
        if withData {
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                let fadeTextAnimation = CATransition()
                fadeTextAnimation.duration = 0.5
                fadeTextAnimation.type = .fade
                self.navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
                self.navigationController?.navigationBar.layer.animation(forKey: "fadeText")
                
            }) { (complete) in
                if complete {
                    self.navigationItem.title = "\(data.city.name) \(CountryRepresentationConverter.getFlag(fromCountry: data.city.country))"
                    self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
                }
            }
            
        }
    }
}

extension MainViewController: UpdateViewWithData {
    
    func updateView(withGeneralData data: EightDayForecastData) {
        generalData = data
    }
    
    func updateView(withDetailData data: ThreeHoursForecastData) {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        
        guard let data = generalData else { return cell }
        
        let cellSize = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.rowHeight)
        cell.container.backgroundColor = GradientColorMaker.colorWithGradient(frame: cellSize, colors: K.cellColor, direction: .Down)
        
        let day = data.daily[indexPath.row]
        
        cell.dayLabel.text = DateConverter.convertToDay(forTimeZoneWithOffset: data.timezone_offset, fromUnixTime: day.dt)
        cell.monthLabel.text = DateConverter.convertToMonth(forTimeZoneWithOffset: data.timezone_offset, fromUnixTime: day.dt)
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
        dvc.timeOffset = data.timezone_offset
        dvc.dailyData = day
        dvc.hourlyData = specificData.list.filter({
            let date = ISOTimeConverter.getFullDate(offset: specificData.city.timezone, unix: $0.dt)
            return date == ISOTimeConverter.getFullDate(offset: data.timezone_offset, unix: day.dt)
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

