//
//  SmallerDetailView.swift
//  FutuWeather
//
//  Created by Piotr Kłobukowski on 16/06/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class SmallerDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        categoryLabelSetup()
        collectionViewSetup()
        constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Section
    
    private func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 185)
        layout.scrollDirection = .horizontal
                
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "\(DetailCollectionViewCell.self)")
        collectionView?.backgroundColor = UIColor.clear
        
        addSubview(collectionView!)
    }
    
    private func categoryLabelSetup() {
        category.backgroundColor = UIColor.clear
        addSubview(category)
    }
    
    private func constraintsSetup() {
        NSLayoutConstraint.activate([category.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     category.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     category.topAnchor.constraint(equalTo: topAnchor),
                                     category.bottomAnchor.constraint(equalTo: collectionView!.topAnchor),
                                     collectionView!.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     collectionView!.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     collectionView!.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    // MARK: - Properties Section
    
    var collectionView: UICollectionView?
    var category: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Press cell for more info"
        return label
    }()
    
    // MARK: - Animations Section
    
    func titleChangeAnimation(withTitle title: String) {
        
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
    
    func dataReloadAdnimation() {
        UIView.animate(withDuration: 0.6, animations: {
            self.collectionView?.alpha = 0.0
        }) { (complete) in
            self.collectionView?.reloadData()
            self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
            UIView.animate(withDuration: 0.6) {
                self.collectionView?.alpha = 1.0
            }
        }
    }
    
}
