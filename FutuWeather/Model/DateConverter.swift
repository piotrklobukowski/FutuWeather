//
//  DateConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 28/04/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct DateConverter {
    
    private enum Months: Substring {
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
    
    private static func convertMonth(from month: Months, asShortcut shortcut: Bool) -> String {
        var string = String()
        
        switch month {
        case .january:
            string = "January"
        case .february:
            string = "February"
        case .march:
            string = "March"
        case .april:
            string = "April"
        case .may:
            string = "May"
        case .june:
            string = "June"
        case .july:
            string = "July"
        case .august:
            string = "August"
        case .september:
            string = "September"
        case .october:
            string = "October"
        case .november:
            string = "November"
        case .december:
            string = "December"
        }
        
        if shortcut {
            string = string.prefix(3).uppercased()
        }
        
        return string
    }

    static func convertToFullDate(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        guard let month = Months.init(rawValue: splitedDate[1]) else { return "nil" }
        
        return "\(splitedDate[2]) \(convertMonth(from: month, asShortcut: false)) \(splitedDate[0])"
    }
    
    static func convertToDay(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        return String(splitedDate[2])
    }
    
    static func convertToMonth(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let date = ISOTimeConverter.getFullDate(offset: offset, unix: unix)
        let splitedDate = date.split(separator: "-")
        guard let month = Months.init(rawValue: splitedDate[1]) else { return "nil" }
        return convertMonth(from: month, asShortcut: true)
    }
    
}

struct HourConverter {
    
    static func convertHour(forTimeZoneWithOffset offset: Int, fromUnixTime unix: Int) -> String {
        let hour = ISOTimeConverter.getTime(offset: offset, unix: unix)
        return String(hour.dropLast(3))
    }
    
}
