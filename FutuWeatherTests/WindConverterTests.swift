//
//  WindConverterTests.swift
//  FutuWeatherTests
//
//  Created by Piotr Kłobukowski on 27/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import FutuWeather

class WindConverterTests: XCTestCase {
    var windDeg: Double?
    var windSpeed: Double?
    var result: String?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDegreesConvertion_N() {
        windDeg = 337.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "N")
        
        windDeg = 22.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "N")
    }
    
    func testDegreesConvertion_NE() {
        windDeg = 22.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "NE")
        
        windDeg = 67.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "NE")
    }
    
    func testDegreesConvertion_E() {
        windDeg = 67.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "E")
        
        windDeg = 112.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "E")
    }
    
    func testDegreesConvertion_SE() {
        windDeg = 112.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "SE")
        
        windDeg = 157.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "SE")
    }

    func testDegreesConvertion_S() {
        windDeg = 157.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "S")
        
        windDeg = 202.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "S")
    }
    
    func testDegreesConvertion_SW() {
        windDeg = 202.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "SW")
        
        windDeg = 247.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "SW")
    }
    
    func testDegreesConvertion_W() {
        windDeg = 247.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "W")
        
        windDeg = 292.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "W")
    }
    
    func testDegreesConvertion_NW() {
        windDeg = 292.6
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "NW")
        
        windDeg = 337.5
        result = WindConverter.getWindDirection(with: windDeg!)
        XCTAssertEqual(result, "NW")
    }
    
    func testSpeedConvertion() {
        windSpeed = 3.04
        result = WindConverter.convertWindSpeed(from: windSpeed!)
        XCTAssertEqual(result, "11")
    }
    
    func testRoundingInSpeedConvertion() {
        windSpeed = 4.17
        result = WindConverter.convertWindSpeed(from: windSpeed!)
        XCTAssertEqual(result, "15")
    }
}
