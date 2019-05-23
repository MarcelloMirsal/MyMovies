//
//  MovieCell.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 05/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    // MARK:- UI Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Creed II"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.numberOfLines = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "November 21, 2018"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = .lightGray
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Drama"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = .lightGray
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "poster")
        return imageView
    }()
    
    let gradientLayer = CAGradientLayer()
    
    
    // MARK:- Methods
    func setupGradientLayer() {
        gradientLayer.colors = [ UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [ 0 , 0.4 , 1 ]
        layer.insertSublayer(gradientLayer, above: posterImageView.layer)
        gradientLayer.frame = bounds
    }
    
    func setupCellShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 20)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 25
    }
    
    // MARK:- Life Cycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupViews()
        setupGradientLayer()
        setupCellShadow()
    }
}

// MARK:- Auto Layout Implementation
extension MovieCell {
    func setupViews(){
        
        // MARK: posterImageView
        addSubview(posterImageView)
        posterImageView.setConstraint(for: posterImageView.topAnchor, to: topAnchor)
        posterImageView.setConstraint(for: posterImageView.leadingAnchor, to: leadingAnchor)
        posterImageView.setConstraint(for: posterImageView.trailingAnchor, to: trailingAnchor)
        posterImageView.setConstraint(for: posterImageView.bottomAnchor, to: bottomAnchor)
        
        //MARK: dateLabel
        addSubview(dateLabel)
        dateLabel.setConstraint(for: dateLabel.topAnchor, to: topAnchor, constant: 16)
        dateLabel.setConstraint(for: dateLabel.leadingAnchor, to: leadingAnchor, constant: 16)
        dateLabel.setConstraint(for: dateLabel.trailingAnchor, to: trailingAnchor)
        dateLabel.heightAnchor.constraint(equalToConstant: 16)
        
        //MARK: titleLabel
        addSubview(titleLabel)
        titleLabel.setConstraint(for: titleLabel.topAnchor, to: dateLabel.bottomAnchor)
        titleLabel.setConstraint(for: titleLabel.leadingAnchor, to: leadingAnchor, constant: 12)
        titleLabel.setConstraint(for: titleLabel.trailingAnchor, to: trailingAnchor)
        titleLabel.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        //MARK: genreLabel
        addSubview(genreLabel)
        genreLabel.setConstraint(for: genreLabel.topAnchor, to: titleLabel.bottomAnchor)
        genreLabel.setConstraint(for: genreLabel.leadingAnchor, to: leadingAnchor, constant: 16)
        genreLabel.setConstraint(for: genreLabel.trailingAnchor, to: trailingAnchor)
        genreLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
