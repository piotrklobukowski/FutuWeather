//
//  SmallerDetailViewController.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 06/07/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class SmallerDetailViewController: UIViewController {
    
    var smallerDetailView: SmallerDetailView = {
        let sdv = SmallerDetailView()
        sdv.translatesAutoresizingMaskIntoConstraints = false
        sdv.backgroundColor = Constants.barColor
        return sdv
    }()
    
    var hours: [String]?
    var info: [String]?
    var iconsData: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(smallerDetailView)
        constraintActivate()
        smallerDetailView.collectionView?.dataSource = self
    }
    
    private func constraintActivate() {
        NSLayoutConstraint.activate([smallerDetailView.topAnchor.constraint(equalTo: view.topAnchor),
                                     smallerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     smallerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     smallerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func reloadData(title: String, info: [String], icons: [Int]?) {
        smallerDetailView.titleChangeAnimation(withTitle: title)
        self.info = info
        
        if let icn = icons {
            iconsData = icn
        } else {
            iconsData = nil
        }
        smallerDetailView.dataReloadAdnimation()
    }
}

extension SmallerDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cells = hours else { return 0 }
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DetailCollectionViewCell.self)", for: indexPath) as! DetailCollectionViewCell
        
        guard let hrs = hours, let inf = info else { return cell }
        
        cell.descriptionLbl.text = inf[indexPath.row]
        cell.hourLbl.text = hrs[indexPath.row]
        
        guard let icn = iconsData else {
            cell.icon.isHidden = true
            return cell
        }
        cell.icon.isHidden = false
        cell.icon.image = WeatherConditionConverter.prepareIcon(forWeatherCondition: icn[indexPath.row])
        
        return cell
    }
}
