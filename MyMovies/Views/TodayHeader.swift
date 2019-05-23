//
//  TodayHeader.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 05/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class TodayHeader: UICollectionViewCell {
    
    // MARK:- UI Properties
    let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().customDate(from: nil)
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK:- Life Cycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        backgroundColor = .clear
        setupViews()
    }
    
}

//MARK:- Auto Layout Implementation
extension TodayHeader {
    func setupViews(){
        
        //MARK: todayLabel
        addSubview(todayLabel)
        todayLabel.setConstraint(for: todayLabel.bottomAnchor, to: bottomAnchor, constant: -4)
        todayLabel.setConstraint(for: todayLabel.leadingAnchor, to: leadingAnchor)
        todayLabel.setConstraint(for: todayLabel.trailingAnchor, to: trailingAnchor)
        todayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //MARK: dateLabel
        addSubview(dateLabel)
        dateLabel.setConstraint(for: dateLabel.topAnchor, to: topAnchor, constant: 4)
        dateLabel.setConstraint(for: dateLabel.leadingAnchor, to: leadingAnchor)
        dateLabel.setConstraint(for: dateLabel.trailingAnchor, to: trailingAnchor)
        dateLabel.heightAnchor.constraint(equalToConstant: 24)
    }
    
}
