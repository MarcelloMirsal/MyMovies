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
