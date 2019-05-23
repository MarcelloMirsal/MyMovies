//
//  NetworkConstants.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 09/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

final class NetworkConstants {
    
    static let demoUser = "Marcello14"
    static let demoPassword = "05430188153"
    
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
        case searchQuery = "query"
        case requestToken = "request_token"
        case sessionId = "session_id"
        
        private enum ApiQueryItemsValues: String {
            case language = "en-US"
            case sortBy = "popularity.desc"
        }
        
        static func query(for item: ApiQueryItems, at page: Int = 1, value: String = "" ) -> URLQueryItem {
            switch item {
            case .apiKey:
                return URLQueryItem(name: item.rawValue, value: NetworkConstants.ApiKeys.api.rawValue)
            case .language:
                return URLQueryItem(name: item.rawValue, value: ApiQueryItemsValues.language.rawValue)
            case .sortBy:
                return URLQueryItem(name: item.rawValue, value: ApiQueryItemsValues.sortBy.rawValue)
            case .page:
                return URLQueryItem(name: item.rawValue, value: "\(page)")
            case .searchQuery:
                return URLQueryItem(name: item.rawValue, value: value)
            case .requestToken:
                return URLQueryItem(name: item.rawValue, value: "")
            case .sessionId:
                return URLQueryItem(name: item.rawValue, value: NetworkManager.userSession.session_id)
            }
        }
    }
    
    
    enum ApiPaths: String {
        case todayMovies = "/discover/movie"
        case image = "/t/p/w500"
        case search = "/search/movie"
        case requestToken = "/authentication/token/new"
        case tokenValidation = "/authentication/token/validate_with_login"
        case session = "/authentication/session/new"
        case favoriteList = "/account/{account_id}/favorite/movies"
        case watchList = "/account/{account_id}/watchlist/movies"
        case userDetails = "/account"
        case markFavorite = "/account/{account_id}/favorite"
        case markWatchlist = "/account/{account_id}/watchlist"
    }

    
}

enum UserList: String {
    case favorites = "Favorites"
    case watchList = "Watchlist"
}


struct RequestToken: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
    func requestBody(username: String, password: String) -> [String : Any] {
        let params: [String : Any] = [
            "username" : username,
            "password": password,
            NetworkConstants.ApiQueryItems.requestToken.rawValue: request_token ]
        return params
    }
}


struct UserSession: Codable {
    let success: Bool
    let session_id: String
    func requestBody(with validatedRequestToken: String) -> [String : Any] {
        let params: [String : Any] = [
            NetworkConstants.ApiQueryItems.requestToken.rawValue:  validatedRequestToken]
        return params
    }
}
