//
//  SearchPopup.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 02/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchPopupFunctionality {
    func locate()
    func search(forPlace place: String)
    func exitPopup(withData: Bool)
}

class SearchPopup: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundBlur()
        setupContainer()
        setupStack()
        setupStackElements()
        setupDelegates()
        setupDismissingTap()
        showAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Section
    
    private func setupBackgroundBlur() {
        addSubview(backgroundBlur)
        NSLayoutConstraint.activate([backgroundBlur.topAnchor.constraint(equalTo: topAnchor),
                                     backgroundBlur.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     backgroundBlur.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     backgroundBlur.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    private func setupContainer() {
        addSubview(container)
        NSLayoutConstraint.activate([container.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     container.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     container.heightAnchor.constraint(equalToConstant: Customization.containerHeight),
                                     container.widthAnchor.constraint(equalToConstant: Customization.containerWidth)])
        container.backgroundColor = GradientColorMaker.colorWithGradient(frame: bounds, colors: Constants.mainColorGradient, direction: GradientColorMaker.GradientDirection.Down)
    }
    
    private func setupStack() {
        container.addSubview(stack)
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     stack.heightAnchor.constraint(equalToConstant: Customization.stackHeight),
                                     stack.widthAnchor.constraint(equalToConstant: Customization.stackWidth)])
    }
    
    private func setupStackElements() {
        stack.addArrangedSubviews(views: [title, subtitle, searchTextField, loadingView, alertView, searchButton, locationButton, cancelButton])
        NSLayoutConstraint.activate([searchTextField.heightAnchor.constraint(equalToConstant: Customization.searchTextFieldHeight),
                                     loadingView.heightAnchor.constraint(equalToConstant: Customization.loadingViewHeight)])
        
        stack.subviews.forEach({
            $0.widthAnchor.constraint(equalToConstant: Customization.stackWidth).isActive = true
        })
        [cancelButton, searchButton, locationButton].forEach({
            $0.heightAnchor.constraint(equalToConstant: Customization.buttonsHeight).isActive = true
        })
        
        loadingView.isHidden = true
        alertView.isHidden = true
    }
    
    private func setupDelegates() {
        searchTextField.delegate = self
    }
    
    // MARK: - Properties Section
    
    var delegate: SearchPopupFunctionality?
    
    private enum Customization {
        static let containerHeight: CGFloat = 500
        static let containerWidth: CGFloat = 300
        static let containerCornerRadius: CGFloat = 40
        static let searchTextFieldHeight: CGFloat = 40
        static let stackHeight: CGFloat = containerHeight * 0.9
        static let stackWidth: CGFloat = containerWidth * 0.9
        static let buttonsHeight: CGFloat = containerHeight * 0.11
        static let loadingViewHeight: CGFloat = containerHeight * 0.1
        static let shadowRadius: CGFloat = CGFloat(8)
        static let shadowOpacity: Float = Float(0.3)
        static let shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private enum SubviewsFactor {
        static func button(withTitle title: String, andAction action: Selector) -> PopupButton {
            let btn = PopupButton()
            let btnFrame = CGRect(x: 0, y: 0, width: Customization.stackWidth, height: Customization.buttonsHeight)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.layer.cornerRadius = Customization.buttonsHeight / 2
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: action, for: [.touchUpInside])
            btn.backgroundColor = GradientColorMaker.colorWithGradient(frame: btnFrame, colors: Constants.mainColorGradient, direction: GradientColorMaker.GradientDirection.Down)
            return btn
        }
    }
    
    private let backgroundBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.translatesAutoresizingMaskIntoConstraints = false
        return vev
    }()
        
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Search for location"
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = UIColor.white
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "We can use localisation to find your location, or you can specify it by typing below city name, its zip code and name of country:"
        return label
    }()
    
    let searchTextField: PopupTextField = {
        let txtFld = PopupTextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        txtFld.placeholder = "\u{1F50E} Search"
        txtFld.returnKeyType = .search
        txtFld.enablesReturnKeyAutomatically = true
        txtFld.autocapitalizationType = .words
        txtFld.autocorrectionType = .no
        return txtFld
    }()
    
    private let searchButton = SubviewsFactor.button(withTitle: "Search", andAction: #selector(searchPressed))
    private let locationButton = SubviewsFactor.button(withTitle: "Use my location", andAction: #selector(locatePressed))
    private let cancelButton = SubviewsFactor.button(withTitle: "Cancel", andAction: #selector(hideAnimation))
    
    private let alertView: AlertView = {
        let view = AlertView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Customization.containerCornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = Customization.shadowOffset
        view.layer.shadowRadius = Customization.shadowRadius
        view.layer.shadowOpacity = Customization.shadowOpacity
        return view
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    // MARK: - Functionality Section
    
    @objc private func searchPressed() {
        guard let text = searchTextField.text else { searchTextField.resignFirstResponder(); return }
        showLoadingAnimation()
        
        delegate?.search(forPlace: text)
        searchTextField.resignFirstResponder()
    }
    
    @objc private func locatePressed() {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
        showLoadingAnimation()
        delegate?.locate()
    }
    
    private func setupDismissingTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOrPopup))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardOrPopup() {
        if searchTextField.isFirstResponder {
            self.endEditing(true)
        } else {
            hideAnimation()
        }
    }
    
    // MARK: - Animations Section

    @objc func hideAnimation(withData: Bool = false) {
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -(0.5 * self.bounds.height))
            self.container.alpha = 0
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.delegate?.exitPopup(withData: withData)
            }
        }
    }
    
    func showAnimation() {
        container.transform = CGAffineTransform(translationX: 0, y: -(0.5 * self.bounds.height))
        container.alpha = 0
        self.alpha = 0
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.alpha = 1.0
            self.container.transform = .identity
            self.container.alpha = 1.0
        })
    }

    private func hideAlertViewAnimation() {
        guard alertView.isHidden == false else { return }
        UIView.animate(withDuration: 0.2, animations: {
            self.alertView.alpha = 0
            self.searchTextField.layer.borderColor = UIColor.white.cgColor
            self.searchTextField.textColor = UIColor.white
        }, completion: {
            (complete) in
            if complete {
                UIView.animate(withDuration: 0.2) {
                    self.alertView.isHidden = true
                }
            }
        })
    }
    
    func showAlertViewAnimation(message: String, markTextField: Bool) {
        guard alertView.isHidden else { return }
        hideLoadingAnimation()
        alertView.message.text = message
        alertView.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.alertView.isHidden = false
            self.alertView.alpha = 1.0
            if markTextField {
                self.searchTextField.layer.borderColor = Constants.errorColor.cgColor
                self.searchTextField.textColor = Constants.errorColor
            }
        }
    }
    
    private func showLoadingAnimation() {
        guard loadingView.isHidden else { return }
        if alertView.isHidden == false {
            alertView.alpha = 0.0
            alertView.isHidden = true
            searchTextField.layer.borderColor = UIColor.white.cgColor
            searchTextField.textColor = UIColor.white
        }
        loadingView.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.loadingView.isHidden = false
            self.loadingView.alpha = 1.0
        }
        loadingView.dots.loadingAnimation()
    }
    
    func hideLoadingAnimation() {
        guard loadingView.isHidden == false else { return }
        UIView.animate(withDuration: 0.2) {
            self.loadingView.alpha = 0
            self.loadingView.isHidden = true
        }
    }
}

// MARK: - Delegates Section

extension SearchPopup: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else { searchTextField.resignFirstResponder()
            return true }
        showLoadingAnimation()
        print(text)
        delegate?.search(forPlace: text)
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideAlertViewAnimation()
    }
}
