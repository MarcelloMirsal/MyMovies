//
//  NetworkManager.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 09/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class NetworkManager {
    
    
    func response(for apiPath: NetworkConstants.ApiPaths, at page: Int = 1, completion: @escaping (_ dataResponse: DataResponse<Data>) -> ()  ) {
        
        Alamofire.request(URLBuilder.url(for: apiPath, at: page)).responseData { (response) in
            completion(response)
        }
        
    }
    
    func response(imagePath: String, completion: @escaping (_ dataResponse: DataResponse<UIImage>) -> ()) {
        Alamofire.request(URLBuilder.url(for: .image, imagePathURL: imagePath)).responseImage { (dataResponse) in
            completion(dataResponse)
        }
    }
    
    
    init() {
        
    }
}


class URLBuilder {
    
    static func url(for path: NetworkConstants.ApiPaths, at pageNumber: Int = 1, imagePathURL: String = "") -> String {
        
        switch path {
        case .todayMovies:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + NetworkConstants.ApiPaths.todayMovies.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .language),
                NetworkConstants.ApiQueryItems.query(for: .sortBy),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .image:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.imageHost.rawValue
            urlComponents.path = NetworkConstants.ApiPaths.image.rawValue + imagePathURL
            return urlComponents.string!
        }
    }
}
