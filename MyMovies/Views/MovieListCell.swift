//
//  MovieListCell.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 21/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {

    
    // MARK:- Properties
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        return label
    }()
    
    let subtitleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    // MARK:- Methods
    
    
    
    
    // MARK:- Life Cycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        addSubview(posterImageView)
        posterImageView.setConstraint(for: posterImageView.leadingAnchor, to: leadingAnchor, constant: 16)
        posterImageView.setConstraint(for: posterImageView.topAnchor
            , to: topAnchor, constant: 4)
        posterImageView.setConstraint(for: posterImageView.bottomAnchor, to: bottomAnchor, constant: -4)
        posterImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(titleLable)
        titleLable.setConstraint(for: titleLable.leadingAnchor, to: posterImageView.trailingAnchor, constant: 8)
        titleLable.setConstraint(for: titleLable.trailingAnchor, to: trailingAnchor, constant: -4)
        titleLable.setConstraint(for: titleLable.centerYAnchor, to: centerYAnchor)
        //titleLable.setConstraint(for: titleLable.bottomAnchor, to: posterImageView.bottomAnchor)
        titleLable.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5, constant: 4)
        
        addSubview(subtitleLable)
        subtitleLable.setConstraint(for: subtitleLable.topAnchor, to: titleLable.bottomAnchor,constant: 4)
        subtitleLable.setConstraint(for: subtitleLable.leadingAnchor, to: titleLable.leadingAnchor)
        subtitleLable.setConstraint(for: subtitleLable.trailingAnchor, to: titleLable.trailingAnchor)
        subtitleLable.heightAnchor.constraint(equalToConstant: 22).isActive = true

        
    }
    
    
    
}
