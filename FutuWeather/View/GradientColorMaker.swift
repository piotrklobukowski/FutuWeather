//
//  GradientColorMaker.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

struct GradientColorMaker {
    
    enum GradientDirection {
        case Up, Down, Left, Right
    }
    
    static func colorWithGradient(frame: CGRect, colors: [UIColor], direction: GradientDirection) -> UIColor {
        
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = frame
        backgroundGradientLayer.colors = colors.map({$0.cgColor})
        
        switch direction {
        case .Up:
            backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .Down:
            backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .Left:
            backgroundGradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            backgroundGradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .Right:
            backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return colors[0] }
        
        backgroundGradientLayer.render(in: context)
        guard let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext() else { return colors[0] }
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: backgroundColorImage)
    }
}
