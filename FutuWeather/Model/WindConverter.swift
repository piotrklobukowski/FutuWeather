//
//  WindConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 08/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct WindConverter {
    
    static func getWindDirection(with degrees: Double) -> String {
        switch degrees {
        case 0...22.5:
            return "N"
        case 337.51...360:
            return "N"
        case 22.51...67.5:
            return "NE"
        case 67.51...112.5:
            return "E"
        case 112.51...157.5:
            return "SE"
        case 157.51...202.5:
            return "S"
        case 202.51...247.5:
            return "SW"
        case 247.51...292.5:
            return "W"
        case 292.51...337.5:
            return "NW"
        default:
            return "nil"
        }
    }
    
    static func convertWindSpeed(from speed: Double) -> String {
        let value = (speed * 3.6).rounded()
        return String(Int(value))
    }
}
