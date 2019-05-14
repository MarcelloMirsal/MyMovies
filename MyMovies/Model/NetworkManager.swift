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
    
    
    private static var validatedRequestToken: RequestToken!
    private static var userSession: UserSession!

    
    func response(for apiPath: NetworkConstants.ApiPaths, at page: Int = 1, value: String = "", completion: @escaping (_ dataResponse: DataResponse<Data>) -> ()  ) {
        
        Alamofire.request(URLBuilder.url(for: apiPath, at: page, value: value)).responseData { (response) in
            completion(response)
        }
    }
    
    
    func responseToken(username: String, password: String, completion: @escaping (_ isValidated: Bool, RequestTokenError?) -> () ) {
        Alamofire.request(URLBuilder.url(for: .requestToken)).responseData { (tokenResponse) in
            if let _ = tokenResponse.error {
                completion(false, .noResponse)
                return
            }
            guard let tokenData = tokenResponse.data else {
                completion(false, .dataUnwrapping)
                return
            }
            guard let requestToken = try? JSONDecoder().decode(RequestToken.self, from: tokenData) else {
                completion(false, .dataDecoding)
                return
            }
            
            let validationURL = URLBuilder.url(for: .tokenValidation)
            let params = requestToken.requestBody(username: username, password: password)
            
            Alamofire.request(validationURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData(completionHandler: { (validationResponse) in
                
                if let _ = tokenResponse.error {
                    completion(false, .noResponse)
                    return
                }
                
                guard let validationData = validationResponse.data else {
                    completion(false, .dataUnwrapping)
                    return
                }
                guard let validatedRequestToken = try? JSONDecoder().decode(RequestToken.self, from: validationData) else {
                    completion(false, .dataDecoding)
                    return
                }
                NetworkManager.validatedRequestToken = validatedRequestToken
                
                // MARK:- create User session
                let userSessionParams = [NetworkConstants.ApiQueryItems.requestToken.rawValue: NetworkManager.validatedRequestToken.request_token]
                
                Alamofire.request(URLBuilder.url(for: .session), method: .post, parameters: userSessionParams, encoding: JSONEncoding.default, headers: nil).responseData(completionHandler: { (sessionDataResponse) in
                    if let _ = sessionDataResponse.error {
                        completion(false, .noResponse)
                        return
                    }
                    
                    guard let sessionData = sessionDataResponse.data else {
                        completion(false, .dataUnwrapping)
                        return
                    }
                    guard let validatedSession = try? JSONDecoder().decode(UserSession.self, from: sessionData) else {
                        completion(false, .dataDecoding)
                        return
                    }
                    if !validatedSession.success {
                        completion(false, .sessionDenied)
                        return
                    }
                    NetworkManager.userSession = validatedSession
                    completion(NetworkManager.userSession.success,nil)
                })
            })
            
        }
    }
    
    func response(imagePath: String, completion: @escaping (_ dataResponse: DataResponse<UIImage>) -> ()) {
        Alamofire.request(URLBuilder.url(for: .image, value: imagePath)).responseImage { (dataResponse) in
            completion(dataResponse)
        }
    }
    
    init() {
        
    }
}


class URLBuilder {
    
    
    // value: Parameter is Used to pass:
    // 1- the path of an image
    // 2- set the search query
    static func url(for path: NetworkConstants.ApiPaths, at pageNumber: Int = 1, value: String = "") -> String {
        
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
        }
    }
}

enum RequestTokenError: Error {
    case noResponse
    case dataUnwrapping
    case dataDecoding
    case sessionDenied
    
    var localizedDescription: String {
        switch self {
        case .noResponse:
            return "No Response from api, check URL or network"
        case .dataUnwrapping:
            return "Found nil while unwrapping data from dataResponse"
        case .dataDecoding:
            return "Error while trying to decode JSON, check User's info OR codingKeys for RequestToken."
        case .sessionDenied:
            return "Session is not validated, try again"
        }
    }
}
