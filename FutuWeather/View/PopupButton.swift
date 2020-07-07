//
//  PopupButton.swift
//  ThingsForFutuWeather
//
//  Created by Piotr Kłobukowski on 29/05/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class PopupButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonView()
        setupAnimatingPressActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum Customization {
        static let shadowRadius: CGFloat = 8
        static let shadowOpacity: Float = 0.3
        static let shadowOffset = CGSize(width: 0, height: 5)
        static let fontSize: CGFloat = 21
        static let shadowColor: UIColor = .black
        static let tintColor: UIColor = .white
    }
    
    private func setupButtonView() {
        layer.shadowColor = Customization.shadowColor.cgColor
        layer.shadowOffset = Customization.shadowOffset
        layer.shadowRadius = Customization.shadowRadius
        layer.shadowOpacity = Customization.shadowOpacity
        tintColor = Customization.tintColor
        titleLabel?.font = UIFont.systemFont(ofSize: Customization.fontSize, weight: .regular)
    }
    
    private func setupAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
                        
        }, completion: nil)
    }
}
