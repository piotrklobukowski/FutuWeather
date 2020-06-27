//
//  DateConverterTests.swift
//  FutuWeatherTests
//
//  Created by Piotr Kłobukowski on 27/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import XCTest
@testable import FutuWeather

class DateConverterTests: XCTestCase {
    
    var dt: Int?
    var offset = 7200

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDayConversion() {
        dt = 1587981600
        let result = ISOTimeConverter.getFullDate(offset: offset, unix: dt!)
        XCTAssertEqual(result, "2020-04-27")
    }
    
    func testDayConversion_shortBeforeMidnight() {
        dt = 1588024740
        let result = ISOTimeConverter.getFullDate(offset: offset, unix: dt!)
        XCTAssertEqual(result, "2020-04-27")
    }
    
    func testDayConversion_shortAfterMidnight() {
        dt = 1587938460
        let result = ISOTimeConverter.getFullDate(offset: offset, unix: dt!)
        XCTAssertEqual(result, "2020-04-27")
    }
}
