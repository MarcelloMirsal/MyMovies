//
//  NetworkConstants.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 09/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

final class NetworkConstants {
    
    enum ApiKeys: String {
        case api = "6203d05815ada391f8b581d00ebbdbd5"
        case version = "/3"
        case scheme = "https"
        case host = "api.themoviedb.org"
        case imageHost = "image.tmdb.org"
    }
    
    enum ApiQueryItems: String {
        case apiKey = "api_key"
        case language = "language"
        case sortBy = "sort_by"
        case page
        
        private enum ApiQueryItemsValues: String {
            case language = "en-US"
            case sortBy = "popularity.desc"
        }
        
        static func query(for item: ApiQueryItems, at page: Int = 1) -> URLQueryItem {
            switch item {
            case .apiKey:
                return URLQueryItem(name: item.rawValue, value: NetworkConstants.ApiKeys.api.rawValue)
            case .language:
                return URLQueryItem(name: item.rawValue, value: ApiQueryItemsValues.language.rawValue)
            case .sortBy:
                return URLQueryItem(name: item.rawValue, value: ApiQueryItemsValues.sortBy.rawValue)
            case .page:
                return URLQueryItem(name: item.rawValue, value: "\(page)")
            }
        }
    }
    
    
    enum ApiPaths: String {
        case todayMovies = "/discover/movie"
        case image = "/t/p/w500"
    }
    
}
