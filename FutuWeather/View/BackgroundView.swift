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
        backgroundImage = UIImage(named: imageName)!
        backgroundImageView = UIImageView(frame: frame)
        backgroundColorView = UIView(frame: frame)
        self.color = color
        super.init(frame: frame)
        setUpBackground()
    }
    
    required init?(coder: NSCoder) {
        backgroundImage = UIImage()
        backgroundImageView = UIImageView()
        backgroundColorView = UIView()
        self.color = UIColor()
        super.init(coder: coder)
    }
    
    private var backgroundImage: UIImage
    private var color: UIColor
    private var backgroundImageView: UIImageView
    private var backgroundColorView: UIView
    
    private func setUpBackground() {
        backgroundImageView.image = backgroundImage
        backgroundColorView.backgroundColor = color
        addSubview(backgroundImageView)
        addSubview(backgroundColorView)
    }
}
