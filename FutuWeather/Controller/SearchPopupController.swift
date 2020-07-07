//
//  SearchPopupController.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 02/07/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CoreLocation

protocol UpdateViewWithData {
    func updateMainView(withData: Bool)
}

class SearchPopupController: UIViewController {
    
    var searchPopup: SearchPopup?
    let locationManager = LocationManager()
    let weatherManager = WeatherManager()
    var delegate: UpdateViewWithData?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchPopup = SearchPopup(frame: UIScreen.main.bounds)
        guard let sp = searchPopup else { return }
        view.addSubview(sp)
        sp.showAnimation()
        setupDelegates()
    }
    
    private func setupDelegates() {
        searchPopup?.delegate = self
        locationManager.delegate = self
        locationManager.errorDelegate = self
        weatherManager.handlerDelegate = self
        weatherManager.delegate = parent as? UpdateControllerWithData
        
    }
    
}

extension SearchPopupController: SearchPopupFunctionality {

    func locate() {
        locationManager.provideLocation()
    }
    
    func search(forPlace place: String) {
        let placeFinder = PlaceFinder()
        placeFinder.delegate = weatherManager
        placeFinder.errorDelegate = self
        placeFinder.findPlace(of: place)
    }
    
    func exitPopup(withData: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.removeFromParent()
        self.view.removeFromSuperview()
        delegate?.updateMainView(withData: withData)
    }
}

extension SearchPopupController: LocationFromLocationManager {
    
    func getData(usingLocation location: CLLocation) {
        let lon = String(location.coordinate.longitude)
        let lat = String(location.coordinate.latitude)
        
        weatherManager.fetchWeather(forLongitude: lon, andLatitude: lat)
    }
}

extension SearchPopupController: ErrorFromLocationManager {
    
    func showLocationManagerError(error: CLError) {
        print("ERROR FROM LOCATION MANAGER: \(error)")
        var message: String
        
        switch error.code {
        case .denied:
            message = "You must first allow to use localisation services"
        case .network:
            message = "There is problem with internet connection"
        default:
            message = "There is problem with localisation services"
        }
        
        searchPopup?.showAlertViewAnimation(message: message, markTextField: false)
    }
    
}

extension SearchPopupController: ErrorFromPlaceFinder {
    func showPlaceFinderError(er: CLError) {
        print("ERROR FROM PLACE FINDER: \(er.localizedDescription)")
        
        switch er.code {
        case .geocodeFoundNoResult:
            searchPopup?.showAlertViewAnimation(message: "We can't find this city", markTextField: true)
        default:
            searchPopup?.showAlertViewAnimation(message: "There is problem with internet connection", markTextField: false)
        }
    }
}

extension SearchPopupController: WeatherManagerPopupEventHandler {
    func showWeatherManagerError(error: Error) {
        print("ERROR FROM WEATHER MANAGER: \(error)")
        searchPopup?.showAlertViewAnimation(message: "We can't provide weather forecast for this place", markTextField: true)
    }
    
    func hidePopup() {
        searchPopup?.hideAnimation(withData: true)
    }
    
    
}
