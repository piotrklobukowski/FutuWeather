//
//  PlaceFinderTests.swift
//  FutuWeatherTests
//
//  Created by Piotr Kłobukowski on 14/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
import CoreLocation
@testable import FutuWeather

class PlaceFinderTests: XCTestCase {
    
    class Mock: CoordinatesFromPlaceFinder, ErrorFromPlaceFinder {
        
        var testcoord: [String: String]?
        var error: CLError?
        
        func searchDataWithCoordinates(coor: [String : String]) {
            testcoord = coor
        }
        
        func showPlaceFinderError(er: CLError) {
            error = er
        }
    }
    
    var sut: PlaceFinder?
    var mock: Mock?
    
    override func setUp() {
        super.setUp()
        sut = PlaceFinder()
        mock = Mock()
        sut?.delegate = mock
        sut?.errorDelegate = mock
    }
    
    override func tearDown() {
        sut = nil
        mock = nil
        super.tearDown()
    }
    
    func testFindPlace() {
        let exp = expectation(description: "Time for looking for placemark")
        sut?.findPlace(of: "Pcim")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        XCTAssertNotNil(mock?.testcoord)
        XCTAssertEqual(mock?.testcoord!["lon"], "19.9815103")
        XCTAssertEqual(mock?.testcoord!["lat"], "49.7693581")
    }
    
    func testFindePlace() {
        let exp = expectation(description: "Time for looking for placemark")
        sut?.findPlace(of: "Gdańsk")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        XCTAssertNotNil(mock?.testcoord)
        XCTAssertEqual(mock?.testcoord!["lon"], "18.652843")
        XCTAssertEqual(mock?.testcoord!["lat"], "54.348568")
    }
    
    func testShowError() {
        let exp = expectation(description: "Time for looking for placemark")
        sut?.findPlace(of: "ksdjhfkjzhfbkjsh")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        XCTAssertNil(mock?.testcoord)
        XCTAssertNotNil(mock?.error)
        XCTAssertEqual(mock?.error?.code, CLError.geocodeFoundNoResult)
    }
}
