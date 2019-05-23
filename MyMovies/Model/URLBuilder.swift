//
//  URLBuilder.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 15/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

class URLBuilder {
    
    class func url(for path: NetworkConstants.ApiPaths, at pageNumber: Int = 1, value: String = "") -> String {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
        urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
        urlComponents.path = NetworkConstants.ApiKeys.version.rawValue
        
        switch path {
        case .todayMovies:
            urlComponents.path += path.rawValue
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
            urlComponents.path = NetworkConstants.ApiPaths.image.rawValue + value
            return urlComponents.string!
        case .search:
            urlComponents.path += path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .language),
                NetworkConstants.ApiQueryItems.query(for: .searchQuery, at: pageNumber, value: value),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .requestToken:
            urlComponents.path += path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .tokenValidation:
            urlComponents.path += path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .session:
            urlComponents.path += path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .favoriteList:
            urlComponents.path += path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId ?? 0 )")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId),
                NetworkConstants.ApiQueryItems.query(for: .language),
                URLQueryItem(name: NetworkConstants.ApiQueryItems.sortBy.rawValue, value: "created_at.asc"),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .watchList:
            urlComponents.path += path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId!)")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .language),
                NetworkConstants.ApiQueryItems.query(for: .sessionId),
                URLQueryItem(name: NetworkConstants.ApiQueryItems.sortBy.rawValue, value: "created_at.asc"),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .userDetails:
            urlComponents.path += path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId)
            ]
            return urlComponents.string!
        case .markFavorite:
            urlComponents.path += path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId!)")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId)
            ]
            return urlComponents.string!
        case .markWatchlist:
            urlComponents.path += path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId!)")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId)
            ]
            return urlComponents.string!
        }
    }
}

