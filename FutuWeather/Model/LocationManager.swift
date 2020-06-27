//
//  LocationManager.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 30/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import CoreLocation


protocol LocationFromLocationManager {
    func getData(usingLocation location: CLLocation)
}

protocol ErrorFromLocationManager {
    func showLocationManagerError(error: CLError)
}

class LocationManager: NSObject {
    
    override init() {
        super.init()
    }
    
    var delegate: LocationFromLocationManager?
    var errorDelegate: ErrorFromLocationManager?

    private lazy var locationManager: CLLocationManager = {
        let lctMng = CLLocationManager()
        lctMng.desiredAccuracy = kCLLocationAccuracyKilometer
        lctMng.requestWhenInUseAuthorization()
        return lctMng
    }()
        
    func provideLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        delegate?.getData(usingLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let er = error as! CLError
        errorDelegate?.showLocationManagerError(error: er)
    }
}
