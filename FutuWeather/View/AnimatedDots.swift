//
//  AnimatedDots.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class AnimatedDots: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rep.addSublayer(dot)
        layer.addSublayer(rep)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var rep: CAReplicatorLayer = {
        let rep = CAReplicatorLayer()
        rep.instanceCount = 4
        rep.instanceTransform = CATransform3DMakeTranslation(15, 0, 0)
        rep.instanceDelay = 0.25
        
        return rep
    }()
    
    let dot: CAShapeLayer = {
        let shape = CAShapeLayer()
        
        shape.frame.size = CGSize(width: 10, height: 10)
        shape.path = CGPath(ellipseIn: shape.frame, transform: nil)
        shape.fillColor = UIColor.white.cgColor
        
        return shape
    }()
    
    func loadingAnimation() {
        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .repeat, animations: {
            
            
            self.rep.sublayers?.forEach({
                
                let animUpDown = CABasicAnimation(keyPath: "position.y")
                
                animUpDown.byValue = (-2 * $0.frame.height)
                animUpDown.duration = 0.5
                animUpDown.autoreverses = true
                animUpDown.repeatCount = .infinity
                animUpDown.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                
                $0.add(animUpDown, forKey: "position.y")
                
                CATransaction.begin()
                
                guard let animation = $0.animation(forKey: "position.y") else { CATransaction.disableActions(); return }
                
                CATransaction.setAnimationDuration(animation.duration)
                CATransaction.setAnimationTimingFunction(animation.timingFunction)
                
                CATransaction.commit()
            })
        }, completion: nil)
    }
}

