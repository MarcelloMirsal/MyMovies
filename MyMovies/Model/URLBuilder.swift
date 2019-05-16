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
            urlComponents.path = NetworkConstants.ApiPaths.image.rawValue + value
            return urlComponents.string!
        case .search:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + NetworkConstants.ApiPaths.search.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .language),
                NetworkConstants.ApiQueryItems.query(for: .searchQuery, at: pageNumber, value: value),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .requestToken:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + NetworkConstants.ApiPaths.requestToken.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .tokenValidation:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + NetworkConstants.ApiPaths.tokenValidation.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .session:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + NetworkConstants.ApiPaths.session.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
            ]
            return urlComponents.string!
        case .favoriteList:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId!)")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId),
                NetworkConstants.ApiQueryItems.query(for: .language),
                URLQueryItem(name: NetworkConstants.ApiQueryItems.sortBy.rawValue, value: "created_at.asc"),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
        case .watchList:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + path.rawValue
            urlComponents.path = urlComponents.path.replacingOccurrences(of: "{account_id}", with: "\(NetworkManager.userId!)")
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .language),
                NetworkConstants.ApiQueryItems.query(for: .sessionId),
                URLQueryItem(name: NetworkConstants.ApiQueryItems.sortBy.rawValue, value: "created_at.asc"),
                NetworkConstants.ApiQueryItems.query(for: .page, at: pageNumber)
            ]
            return urlComponents.string!
            //https://api.themoviedb.org/3/account/{account_id}/watchlist/movies?api_key=6203d05815ada391f8b581d00ebbdbd5&language=en-US&session_id=515f35d5ff224e61eb245f39224ebff7434d2099&sort_by=created_at.asc&page=1

        case .userDetails:
            var urlComponents = URLComponents()
            urlComponents.scheme = NetworkConstants.ApiKeys.scheme.rawValue
            urlComponents.host = NetworkConstants.ApiKeys.host.rawValue
            urlComponents.path = NetworkConstants.ApiKeys.version.rawValue + path.rawValue
            urlComponents.queryItems = [
                NetworkConstants.ApiQueryItems.query(for: .apiKey),
                NetworkConstants.ApiQueryItems.query(for: .sessionId)
            ]
            return urlComponents.string!
        }
    }
}

