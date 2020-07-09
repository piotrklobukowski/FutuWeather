//
//  WeatherManagerTests.swift
//  FutuWeatherTests
//
//  Created by Piotr Kłobukowski on 27/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import FutuWeather

class WeatherManagerTests: XCTestCase {
    
    class Mock: UpdateControllerWithData {
        
        var updatedGeneralData: EightDayForecastData?
        var updatedDetailData: ThreeHoursForecastData?
        
        func updateController(withGeneralData data: EightDayForecastData) {
            updatedGeneralData = data
        }
        
        func updateController(withDetailData data: ThreeHoursForecastData) {
            updatedDetailData = data
        }
    }
    
    var sut: WeatherManager?
    var lon: String?
    var lat: String?
    var mock: Mock?
    
    override func setUp() {
        super.setUp()
        sut = WeatherManager()
        mock = Mock()
        sut?.delegate = mock
        lon = "19.67"
        lat = "52.86"
    }
    
    override func tearDown() {
        sut = nil
        mock = nil
        super.tearDown()
    }
    
    func testGetDataFromJSON() {
        let exp = expectation(description: "Time for networking passed")
        sut?.fetchWeather(forLongitude: lon!, andLatitude: lat!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 3.0)
        
        XCTAssertNotNil(mock?.updatedGeneralData)
        XCTAssertNotNil(mock?.updatedDetailData)
    }
    
    func testGetDataFromJSON_getFullData() {
        let exp = expectation(description: "Time for networking passed")
        
        sut?.fetchWeather(forLongitude: lon!, andLatitude: lat!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 3.0)
        
        XCTAssertEqual(mock?.updatedGeneralData?.daily.count, 8)
        XCTAssertEqual(mock?.updatedDetailData?.list.count, 40)
        XCTAssertNotNil(mock?.updatedGeneralData?.daily[3].dt)
        XCTAssertNotNil(mock?.updatedDetailData?.list[20].main.temp)
    }
    
    func testGetSpecificDataFromJSON_city() {
        let exp = expectation(description: "Time for networking passed")

        sut?.fetchWeather(forLongitude: lon!, andLatitude: lat!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 3.0)
        
        XCTAssertEqual(mock?.updatedDetailData?.city.country, "PL")
        XCTAssertEqual(mock?.updatedDetailData?.city.name, "Sierpc")
    }
    
}
