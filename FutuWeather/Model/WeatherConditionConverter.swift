//
//  WeatherConditionConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 10/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

struct WeatherConditionConverter {
    
    static func prepareIcon(forWeatherCondition WthCon: Int) -> UIImage {
        
        let systemName: String
        
        switch WthCon {
        case 200...202, 230...232:
            systemName = "cloud.bolt.rain"
        case 210...212, 221:
            systemName = "cloud.bolt"
        case 300...302, 310...314, 321:
            systemName = "cloud.drizzle"
        case 500...501, 520...522, 531 :
            systemName = "cloud.rain"
        case 502...504:
            systemName = "cloud.heavyrain"
        case 511, 600...602, 615, 616, 620...622:
            systemName = "snow"
        case 611...613:
            systemName = "cloud.sleet"
        case 711:
            systemName = "smoke"
        case 781:
            systemName = "tornado"
        case 701, 721, 731, 741, 751, 761, 762, 771:
            systemName = "sun.haze"
        case 800:
            systemName = "sun.max"
        case 801:
            systemName = "cloud.sun"
        case 802...804:
            systemName = "cloud"
        default:
            systemName = " "
        }
        
        let imageConf = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: systemName, withConfiguration: imageConf)
        let finalImage = image!.withTintColor(.white, renderingMode: .alwaysOriginal)
        return finalImage
    }
}
