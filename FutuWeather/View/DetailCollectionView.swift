//
//  DetailCollectionView.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 16/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class DetailCollectionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 185)
        layout.scrollDirection = .horizontal
                
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "\(DetailCollectionViewCell.self)")
        collectionView?.backgroundColor = UIColor.clear
        category.backgroundColor = UIColor.clear
        
        addSubview(collectionView!)
        addSubview(category)
        
        NSLayoutConstraint.activate([category.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     category.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     category.topAnchor.constraint(equalTo: topAnchor),
                                     category.bottomAnchor.constraint(equalTo: collectionView!.topAnchor),
                                     collectionView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     collectionView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     collectionView!.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        collectionView?.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties Section
    
    var collectionView: UICollectionView?
    var hours: [String]?
    var info: [String]?
    var iconsData: [Int]?
    
    var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Press cell for more info"
        return label
    }()
    
    // MARK: - Functionality Section
    
    func reloadData(title: String, info: [String], icons: [Int]?) {
        titleChangeAnimation(withTitle: title)
        self.info = info
        
        if let icn = icons {
            iconsData = icn
        } else {
            iconsData = nil
        }
        dataReloadAdnimation()
    }
    
    // MARK: - Animations Section
    
    private func titleChangeAnimation(withTitle title: String) {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.category.transform = CGAffineTransform(translationX: -(self.category.frame.width / 2), y: 0)
            self.category.alpha = 0
        }) { (complete) in
            if complete {
                self.category.text = title
                self.category.transform = CGAffineTransform(translationX: (self.category.frame.width / 3), y: 0)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                    self.category.transform = .identity
                    self.category.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func dataReloadAdnimation() {
        UIView.animate(withDuration: 0.6, animations: {
            self.collectionView?.alpha = 0.0
        }) { (complete) in
            self.collectionView?.reloadData()
            UIView.animate(withDuration: 0.6) {
                self.collectionView?.alpha = 1.0
            }
        }
    }
    
}

// MARK: - Delegates Section

extension DetailCollectionView: UICollectionViewDataSource {
    
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

