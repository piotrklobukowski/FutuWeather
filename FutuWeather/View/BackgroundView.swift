//
//  BackgroundView.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 02/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    init(frame: CGRect, imageName: String, color: UIColor) {
        backgroundImageView = UIImageView(frame: frame)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundColorView = UIView(frame: frame)
        backgroundColorView.backgroundColor = color
        super.init(frame: frame)
        setUpBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var backgroundImageView: UIImageView
    private var backgroundColorView: UIView
    
    private func setUpBackground() {
        addSubview(backgroundImageView)
        addSubview(backgroundColorView)
    }
}
