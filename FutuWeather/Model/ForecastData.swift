//
//  ForecastData.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 12/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct EightDayForecastData: Codable {
    let timezone_offset: Int
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
    let clouds: Int
    let rain: Double?
    let snow: Double?
}

struct Temp: Codable {
    let day: Double
}

struct FeelsLike: Codable {
    let day: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct ThreeHoursForecastData: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let name: String
    let country: String
    let timezone: Int
}

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Rain?
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Rain: Codable {
    let threeHours: Double
    
    private enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}

