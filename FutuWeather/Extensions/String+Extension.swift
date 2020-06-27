//
//  String+Extension.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 22/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation

extension String {
    func capitalizeFirst() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
