//
//  DetailViewController.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 15/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties Section

    var backgroundView: BackgroundView?
    var timeOffset: Int?
    var dailyData: Daily?
    var hourlyData: [List]?
    var tableData: [String : String]?
    var tableDataOrder = [String]()
    
    var detailCollectionView: DetailCollectionView = {
        let cllv = DetailCollectionView()
        cllv.translatesAutoresizingMaskIntoConstraints = false
        cllv.backgroundColor = K.barColor
        return cllv
    }()
    
    var tableView: UITableView = {
       let tblv = UITableView()
        tblv.backgroundColor = UIColor.clear
        tblv.translatesAutoresizingMaskIntoConstraints = false
        tblv.separatorColor = UIColor.white
        tblv.separatorStyle = .singleLine
        tblv.register(DetailTableViewCell.self, forCellReuseIdentifier: "\(DetailTableViewCell.self)")
        return tblv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView = BackgroundView(frame: view.frame, imageName: "background", color: K.backgroundColor)
        view.addSubview(backgroundView!)
        setupCollectionView()
        setupTableView()
        prepareDataToShow()
        
        if let offset = timeOffset, let unix = dailyData?.dt {
            navigationItem.title = DateConverter.convertToFullDate(forTimeZoneWithOffset: offset, fromUnixTime: unix)
        }
    }
    
    // MARK: - Functionality Section
    
    private func setupCollectionView() {
        
        view.addSubview(detailCollectionView)
        
        NSLayoutConstraint.activate([detailCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
                                     detailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     detailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     detailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: detailCollectionView.topAnchor)])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func prepareDataToShow() {
        guard let hourly = hourlyData, let daily = dailyData, let offset = timeOffset else { return }
        
        detailCollectionView.hours = hourly.map({
            HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: $0.dt)
        })
        
        tableDataOrder = ["Temperature (feels like)", "Wind speed (direction)", "Humidity", "Pressure", "Cloudiness", "Weather conditions"]
        
        tableData = ["Temperature (feels like)" : "\(Int(daily.temp.day.rounded()))°C (\(Int(daily.feels_like.day.rounded()))°C)",
            "Wind speed (direction)" : "\(WindConverter.convertWindSpeed(from: daily.wind_speed)) km/h (\(WindConverter.getWindDirection(with: Double(daily.wind_deg))))",
            "Humidity" : "\(daily.humidity)%",
            "Pressure" : "\(daily.pressure) hPa",
            "Cloudiness" : "\(daily.clouds)%",
            "Weather conditions" : "\(daily.weather[0].main)"]
        
        if let rain = daily.rain {
            tableData?.updateValue("\(rain) mm", forKey: "Rain")
            tableDataOrder.append("Rain")
        }
        
        if let snow = daily.snow {
            tableData?.updateValue("\(snow)", forKey: "Snow")
            tableDataOrder.append("Snow")
        }
    }
}

// MARK: - Delegates Section

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hours = hourlyData else { return }
        
        switch indexPath.row {
        case 0:
            let info = hours.map {
                "\(Int($0.main.temp.rounded()))°C \n(\(Int($0.main.feels_like.rounded()))°C)"
            }
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
        case 1:
            let info = hours.map {
                "\(WindConverter.convertWindSpeed(from: $0.wind.speed)) km/h \n(\(WindConverter.getWindDirection(with: Double($0.wind.deg))))"
            }
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
        case 2:
            let info = hours.map {
                "\($0.main.humidity)%"
            }
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
        case 3:
            let info = hours.map {
                "\($0.main.pressure) hPa"
            }
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
        case 4:
            let info = hours.map {
                "\($0.clouds.all)%"
            }
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
        case 5:
            let info = hours.map {
                "\(($0.weather[0].description).capitalizeFirst())"
            }
            
            let icons = hours.map {
                $0.weather[0].id
            }
            
            detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: icons)
        default:
            if dailyData?.rain != nil {
                let info = hours.map {
                    "\($0.rain?.threeHours ?? 0) mm"
                }
                detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
            } else if dailyData?.snow != nil {
                let info = hours.map {
                    "\($0.snow?.threeHours ?? 0)"
                }
                detailCollectionView.reloadData(title: tableDataOrder[indexPath.row], info: info, icons: nil)
            }
        }
        
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = tableData else { return 0 }
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailTableViewCell.self)", for: indexPath) as! DetailTableViewCell
        guard let cellData = tableData else { return cell }
        let key = tableDataOrder[indexPath.row]
        guard let value = cellData[key] else { return cell }
        cell.textLabel?.text = "\(key)"
        cell.detailTextLabel?.text = "\(value)"
        return cell
    }
}
