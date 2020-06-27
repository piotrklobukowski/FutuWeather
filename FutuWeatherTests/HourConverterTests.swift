//
//  HourConverterTests.swift
//  FutuWeatherTests
//
//  Created by Piotr Kłobukowski on 30/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import FutuWeather

class HourConverterTests: XCTestCase {
    var dt: Int?
    var offset = 7200
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHourConvertion_BeforeNoon_FullHour() {
        dt = 1587967200
        let result = HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: dt!)
        XCTAssertEqual(result, "08:00")
    }
    
    func testHourConvertion_BeforeNoon_HalfAnHour() {
        dt = 1587980820
        let result = HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: dt!)
        XCTAssertEqual(result, "11:47")
    }
    
    func testHourConvertion_AtNoon() {
        dt = 1587981600
        let result = HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: dt!)
        XCTAssertEqual(result, "12:00")
    }
    
    func testHourConvertion_AfterNoon_FullHour() {
        dt = 1587988800
        let result = HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: dt!)
        XCTAssertEqual(result, "14:00")
    }
    
    func testHourConvertion_AfterNoon_HalfAnHour() {
        dt = 1588000620
        let result = HourConverter.convertHour(forTimeZoneWithOffset: offset, fromUnixTime: dt!)
        XCTAssertEqual(result, "17:17")
    }

}
