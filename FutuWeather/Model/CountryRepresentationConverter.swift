//
//  CountryRepresentationConverter.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 10/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

struct CountryRepresentationConverter {
        
    static func getFlag(fromCountry country: String) -> String {
        var string = ""
        for unicodeScalar in country.unicodeScalars {
            if let uniSlr = UnicodeScalar(127397 + unicodeScalar.value) {
                string.append(String(uniSlr))
            }
        }
        return string
    }    
}
