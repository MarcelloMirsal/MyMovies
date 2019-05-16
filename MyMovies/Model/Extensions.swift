//
//  Extensions.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult func setConstraint<T>(for anchor: NSLayoutAnchor<T>, to targetAnchor: NSLayoutAnchor<T>, constant: CGFloat = 0 ,activation: Bool = true) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = anchor.constraint(equalTo: targetAnchor, constant: constant)
        constraint.isActive = activation
        return constraint
    }
}

extension Date {
     func customDate(from date: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let stringDate = date {
            let formattedDate = dateFormatter.date(from: stringDate)!
            dateFormatter.dateFormat = "EEEE, MMMM, dd"
            return dateFormatter.string(from: formattedDate)
        } else {
            dateFormatter.dateFormat = "EEEE, MMMM, dd"
            return dateFormatter.string(from: self)
        }
    }
}
