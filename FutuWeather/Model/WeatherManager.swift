//
//  WeatherManager.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 11/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import CoreLocation

protocol UpdateViewWithData {
    func updateView(withGeneralData data: EightDayForecastData)
    func updateView(withDetailData data: ThreeHoursForecastData)
}

protocol WeatherManagerPopupEventHandler {
    func showWeatherManagerError(error: Error)
    func hidePopup()
}

fileprivate enum WeatherDataType: String {
    case generalType = "onecall", detailType = "forecast"
}

class WeatherManager {

    var delegate: UpdateViewWithData?
    var handlerDelegate: WeatherManagerPopupEventHandler?
    
    var decoder = WeatherDecoder()
    var restoredError: Error?

    private let urlSession = URLSession(configuration: .default)
    private func performRequest(forLongitude longitude: String, latitude: String) {
        
        let requestGroup = DispatchGroup()
        let urls = [createURL(lon: longitude, lat: latitude, infoType: .generalType), createURL(lon: longitude, lat: latitude, infoType: .detailType)]
        
        decoder.errorDecoderDelegate = self
        
        urls.forEach {
            requestGroup.enter()
            guard let urlSafe = $0 else { return }
            let task = urlSession.dataTask(with: urlSafe) { (data, response, error) in
                guard error == nil else {
                    self.restoredError = error
                    return
                }
                guard let unwrData = data else { return }
                
                if urlSafe.absoluteString.contains(WeatherDataType.generalType.rawValue) {
                    guard let JSONdata = self.decoder.parseJSON(using: unwrData, forDataType: .generalType) as? EightDayForecastData else { requestGroup.leave()
                        return }
                    self.delegate?.updateView(withGeneralData: JSONdata)
                } else {
                    guard let JSONdata = self.decoder.parseJSON(using: unwrData, forDataType: .detailType) as? ThreeHoursForecastData else { requestGroup.leave()
                        return }
                    self.delegate?.updateView(withDetailData: JSONdata)
                }
                requestGroup.leave()
            }
            task.resume()
        }
        
        requestGroup.notify(queue: .main) {
            guard let er = self.restoredError else {
                self.handlerDelegate?.hidePopup()
                return
            }
            self.handlerDelegate?.showWeatherManagerError(error: er)
            self.restoredError = nil
        }

    }
    
    // ATTENTION: - to get the weather data you have to create an account on openweathermap.org and use your unique API Key.
    
    private func createURL(lon: String, lat: String, infoType: WeatherDataType) -> URL? {
        var urlString = String()
        switch infoType {
        case .generalType:
            urlString = "https://api.openweathermap.org/data/2.5/\(infoType.rawValue)?lat=\(lat)&lon=\(lon)&units=metric&exclude=current,hourly&appid={PASTE YOUR API KEY}"
        case .detailType:
            urlString = "https://api.openweathermap.org/data/2.5/\(infoType.rawValue)?lat=\(lat)&lon=\(lon)&units=metric&appid={PASTE YOUR API KEY}"
        }
        return URL(string: urlString)
    }
        
    func fetchWeather(forLongitude longitude: String, andLatitude latitude: String) {
        performRequest(forLongitude: longitude, latitude: latitude)
    }
}

extension WeatherManager: CoordinatesFromPlaceFinder {
    
    func searchDataWithCoordinates(coor: [String : String]) {
        guard let lon = coor["lon"], let lat = coor["lat"] else { return }
        fetchWeather(forLongitude: lon, andLatitude: lat)
    }
}

extension WeatherManager: ErrorsFromDecoder {
    
    func transferError(error: Error) {
        restoredError = error
    }
}

// MARK: - Weather Decoder

protocol ErrorsFromDecoder {
    func transferError(error: Error)
}

class WeatherDecoder {
    let decoder = JSONDecoder()
    var errorDecoderDelegate: ErrorsFromDecoder?
    
    fileprivate func parseJSON(using data: Data, forDataType dataType: WeatherDataType) -> Codable? {
        var decodedData: Codable?
        
        switch dataType {
        case .generalType:
            do {
                decodedData = try decoder.decode(EightDayForecastData.self, from: data)
            } catch {
                self.errorDecoderDelegate?.transferError(error: error)
                return nil
            }
        case .detailType:
            do {
                decodedData = try decoder.decode(ThreeHoursForecastData.self, from: data)
            } catch {
                self.errorDecoderDelegate?.transferError(error: error)
                return nil
            }
        }
        return decodedData
    }
}


