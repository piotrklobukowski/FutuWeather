//
//  ISOTimeConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 26/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct ISOTimeConverter {
    
    private static var dateFormatter = ISO8601DateFormatter()
    
    static func getFullDate(offset: Int, unix: Int) -> String {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.formatOptions = .withFullDate
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        return dateFormatter.string(from: date)
    }
    
    static func getTime(offset: Int, unix: Int) -> String {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        dateFormatter.formatOptions = [.withTime, .withColonSeparatorInTime]
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        return dateFormatter.string(from: date)
    }
}
