//
//  UIStackView+Extension.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 01/07/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
