//
//  DateConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 28/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct DateConverter {
    
    private enum Month: String {
        case january = "01"
        case february = "02"
        case march = "03"
        case april = "04"
        case may = "05"
        case june = "06"
        case july = "07"
        case august = "08"
        case september = "09"
        case october = "10"
        case november = "11"
        case december = "12"
    }
    
    private static func nameMonth(of month: Month) -> String {
        switch month {
        case .january:
            return "January"
        case .february:
            return "February"
        case .march:
            return "March"
        case .april:
            return "April"
        case .may:
            return "May"
        case .june:
            return "June"
        case .july:
             return "July"
        case .august:
            return "August"
        case .september:
            return "September"
        case .october:
            return "October"
        case .november:
            return "November"
        case .december:
            return "December"
        }
    }
    
    private static func makeShortcut(from month: Month) -> String {
        let fullName = nameMonth(of: month)
        return fullName.prefix(3).uppercased()
    }

    static func convertToFullDate(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        guard let month = Month.init(rawValue: String(splitedDate[1])) else { return "nil" }
        
        return "\(splitedDate[2]) \(nameMonth(of: month)) \(splitedDate[0])"
    }
    
    static func convertToDay(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        return String(splitedDate[2])
    }
    
    static func convertToMonth(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        guard let month = Month.init(rawValue: String(splitedDate[1])) else { return "nil" }
        return makeShortcut(from: month)
    }
    
}

struct HourConverter {
    
    static func convertHour(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let hour = ISOTimeConverter.getTime(offset: offset, unix: unix)
        return String(hour.dropLast(3))
    }
    
}
