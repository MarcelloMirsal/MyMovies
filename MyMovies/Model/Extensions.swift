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
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: formattedDate)
        } else {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: self)
        }
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIAlertController {
    
    convenience init(message title: String) {
        self.init(title: "\(title)\n\n", message: "\n", preferredStyle: .alert)
        addActivityIndicator()
    }
    
    
    func addActivityIndicator(){
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.setConstraint(for: activityIndicator.centerXAnchor, to: view.centerXAnchor)
        activityIndicator.setConstraint(for: activityIndicator.centerYAnchor, to: view.centerYAnchor)
        activityIndicator.startAnimating()
    }

}



