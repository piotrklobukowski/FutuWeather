//
//  PlaceFinder.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 04/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import CoreLocation

protocol CoordinatesFromPlaceFinder {
    func searchDataWithCoordinates(coor: [String: String])
}

protocol ErrorFromPlaceFinder {
    func showPlaceFinderError(er: CLError)
}

class PlaceFinder {
    
    var delegate: CoordinatesFromPlaceFinder?
    var errorDelegate: ErrorFromPlaceFinder?
    
    func findPlace(of name: String) {
        let geo = CLGeocoder()
        geo.geocodeAddressString(name, in: nil) { (placemarks, error) in
            guard error == nil else {
                let clError = error as! CLError
                self.errorDelegate?.showPlaceFinderError(er: clError)
                return }
            guard let placemark = placemarks?.first else { return }
            guard let location = placemark.location else { return }
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            self.delegate?.searchDataWithCoordinates(coor: ["lat": lat,
                                                     "lon": lon])
        }
    }
}
