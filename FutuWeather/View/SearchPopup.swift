//
//  SearchPopup.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 02/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import CoreLocation

protocol OutAnimation {
    func exitPopup(withData: Bool)
}

class SearchPopup: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        addSubview(backgroundBlur)
        
        NSLayoutConstraint.activate([backgroundBlur.topAnchor.constraint(equalTo: topAnchor), backgroundBlur.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     backgroundBlur.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     backgroundBlur.trailingAnchor.constraint(equalTo: trailingAnchor)])
        
        container.backgroundColor = GradientColorMaker.colorWithGradient(frame: bounds, colors: K.mainColorGradient, direction: GradientColorMaker.GradientDirection.Down)
        
        self.addSubview(container)
        
        NSLayoutConstraint.activate([container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     container.heightAnchor.constraint(equalToConstant: 500),
                                     container.widthAnchor.constraint(equalToConstant: 300)])
        
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     stack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.9),
                                     stack.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9),
                                     searchTextField.heightAnchor.constraint(equalToConstant: 40),
                                     loadingView.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1)])
        
        stack.subviews.forEach({
            $0.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        })
        [cancelButton, searchButton, locationButton].forEach({
            $0.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.11).isActive = true
        })
        
        loadingView.isHidden = true
        alertView.isHidden = true
        
        searchTextField.delegate = self
        locationManager.errorDelegate = self
        weatherManager.handlerDelegate = self
        setupDismissingTapForKeyboard()
        
        showAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties Section
    
    var delegate: OutAnimation?
    
    let weatherManager = WeatherManager()
    let locationManager = LocationManager()
    
    let backgroundBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let vev = UIVisualEffectView(effect: blurEffect)
        vev.translatesAutoresizingMaskIntoConstraints = false
        
        return vev
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Search for location"
        
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "We can use localisation to find your location, or you can specify it by typing below city name, its zip code and name of country:"
        
        return label
    }()
    
    lazy var searchTextField: PopupTextField = {
        let txtFld = PopupTextField()
        txtFld.translatesAutoresizingMaskIntoConstraints = false
        txtFld.placeholder = "\u{1F50E} Search"
        txtFld.returnKeyType = .search
        txtFld.enablesReturnKeyAutomatically = true
        txtFld.autocapitalizationType = .words
        txtFld.autocorrectionType = .no
        
        return txtFld
    }()
    
    lazy var searchButton: PopupButton = {
        let btn = PopupButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Search", for: .normal)
        btn.addTarget(self, action: #selector(search), for: [.touchUpInside])
        
        return btn
    }()
    
    let locationButton: PopupButton = {
        let btn = PopupButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Use my location", for: .normal)
        btn.addTarget(self, action: #selector(locate), for: [.touchUpInside])
        
        return btn
    }()
    
    let cancelButton: PopupButton = {
        let btn = PopupButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(hideAnimation), for: [.touchUpInside])
        
        return btn
    }()
    
    let alertView: AlertView = {
        let view = AlertView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, subtitle, searchTextField, loadingView, alertView, searchButton, locationButton, cancelButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        
        return stack
    }()
    
    // MARK: - Functionality Section
    
    @objc func search() {
        guard let text = searchTextField.text else { searchTextField.resignFirstResponder(); return }
        showLoadingAnimation()
        
        getData(forPlace: text)
        searchTextField.resignFirstResponder()
    }
    
    @objc func locate() {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
        
        locationManager.delegate = self
        locationManager.errorDelegate = self
        showLoadingAnimation()
        
        locationManager.provideLocation()
    }
    
    private func setupDismissingTapForKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        self.addGestureRecognizer(tap)
    }
    
    private func getData(forPlace place: String) {
        let placeFinder = PlaceFinder()
        placeFinder.delegate = weatherManager
        placeFinder.errorDelegate = self
        placeFinder.findPlace(of: place)
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
    
    private func showAnimation() {
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
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.alertView.alpha = 0
            self.searchTextField.layer.borderColor = UIColor.white.cgColor
            self.searchTextField.textColor = UIColor.white
            
        }, completion: {
            (complete) in
            if complete {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                    self.alertView.isHidden = true
                })
            }
        })
    }
    
    private func showAlertViewAnimation(message: String, markTextField: Bool) {
        guard alertView.isHidden else { return }
        alertView.message.text = message
        alertView.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.alertView.isHidden = false
            self.alertView.alpha = 1.0
            if markTextField {
                self.searchTextField.layer.borderColor = UIColor(red: 0.89, green: 0.07, blue: 0.07, alpha: 1.00).cgColor
                self.searchTextField.textColor = UIColor(red: 0.89, green: 0.07, blue: 0.07, alpha: 1.00)
            }
        }, completion: nil)
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.loadingView.isHidden = false
            self.loadingView.alpha = 1.0
        }, completion: nil)
        loadingView.dots.loadingAnimation()
    }
    
    private func hideLoadingAnimation() {
        guard loadingView.isHidden == false else { return }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.loadingView.alpha = 0
            self.loadingView.isHidden = true
        }, completion: nil)
    }
}

// MARK: - Delegates Section

extension SearchPopup: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else { searchTextField.resignFirstResponder()
            return true }
        showLoadingAnimation()
        print(text)
        getData(forPlace: text)
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideAlertViewAnimation()
    }
    
}

extension SearchPopup: LocationFromLocationManager {
    
    func getData(usingLocation location: CLLocation) {
        let lon = String(location.coordinate.longitude)
        let lat = String(location.coordinate.latitude)
        
        weatherManager.fetchWeather(forLongitude: lon, andLatitude: lat)
    }
}

extension SearchPopup: WeatherManagerPopupEventHandler {
    
    func hidePopup() {
        hideAnimation(withData: true)
    }
    
    func showWeatherManagerError(error: Error) {
        print("ERROR FROM WEATHER MANAGER: \(error)")
        
        hideLoadingAnimation()
        showAlertViewAnimation(message: "We can't provide weather forecast for this place", markTextField: true)
    }
}

extension SearchPopup: ErrorFromPlaceFinder {
    
    func showPlaceFinderError(er: CLError) {
        print("ERROR FROM PLACE FINDER: \(er.localizedDescription)")
        hideLoadingAnimation()
        
        switch er.code {
        case .geocodeFoundNoResult:
            showAlertViewAnimation(message: "We can't find this city", markTextField: true)
        default:
            showAlertViewAnimation(message: "There is problem with internet connection", markTextField: false)
        }
    }
}

extension SearchPopup: ErrorFromLocationManager {
    
    func showLocationManagerError(error: CLError) {
        print("ERROR FROM LOCATION MANAGER: \(error)")
        hideLoadingAnimation()
        var message: String
        
        switch error.code {
        case .denied:
            message = "You must first allow to use localisation services"
        case .network:
            message = "There is problem with internet connection"
        default:
            message = "There is problem with localisation services"
        }
        
        showAlertViewAnimation(message: message, markTextField: false)
    }
    
}
