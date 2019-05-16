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
    
    /// holds a validated request token.
    public static var validatedRequestToken: RequestToken!
    /// holds a validated user session.
    public static var userSession: UserSession!
    /// holds user id (account id)
    public static var userId: Int!
    

    
    /**
      Get a data response from API.
     
     - Parameter apiPath: the path of requested content.
     - Parameter page: number of page for results.
     - Parameter value: a special parameter used only to set search query, image path.
     - Parameter completion: a block object executed when request ends.
     - Parameter dataResponse: the returned response from request
     ## Important Notes ##
     * the completion block just returns the data response without checking for errors.
     
     */
    func response(for apiPath: NetworkConstants.ApiPaths, at page: Int = 1, value: String = "", completion: @escaping (_ dataResponse: DataResponse<Data>) -> ()  ) {
        
        Alamofire.request(URLBuilder.url(for: apiPath, at: page, value: value)).responseData { (response) in
            completion(response)
        }
    }
    
    
    /**
     create new user session and validate it .
     
     - Parameter username: pass username
     - Parameter password: pass user's password
     - Parameter completion: a block object executed when session request ends.
     - Parameter isValidated: a boolean value indicates if session is successfully granted
     - Parameter error: the type of request error , nil if there is no error
     ## Important Notes ##
     * must check completion parameters to ensure that user session is granted
     */
    func session(username: String, password: String, completion: @escaping (_ isValidated: Bool,_ error: RequestError?) -> () ) {
        Alamofire.request(URLBuilder.url(for: .requestToken)).responseData { (tokenResponse) in
            // MARK: create request token
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
            
            // MARK: validate request token
            
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
                
                // MARK: create User session
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
                    
                    
                    // MARK:- user id details
                    Alamofire.request(URLBuilder.url(for: .userDetails)).responseJSON(completionHandler: { (userDetailsResponse) in
                        guard let userDict = try? JSONSerialization.jsonObject(with: userDetailsResponse.data!, options: .allowFragments) as? Dictionary<String,Any> else {
                            completion(false, .userDetailsDecoding)
                            return
                        }
                        NetworkManager.userId = (userDict["id"] as! Int)
                        print(NetworkManager.validatedRequestToken.request_token)
                        print(NetworkManager.userSession.session_id)
                        completion(NetworkManager.userSession.success,nil)
                    }) // end of user details request
                }) // end of user session request
            }) // end of request token
        }
    }
    
    
    /**
     return data response for image.
     
     - Parameter imagePath: the path of image.
     - Parameter completion: a block object executed when request ends.
     - Parameter dataResponse: the returned response from request.
     ## Important Notes ##
     * the completion block just returns the data response without checking for errors.
     */
    
    func response(imagePath: String, completion: @escaping (_ dataResponse: DataResponse<UIImage>) -> ()) {
        Alamofire.request(URLBuilder.url(for: .image, value: imagePath)).responseImage { (dataResponse) in
            completion(dataResponse)
        }
    }
    
    init() {
        
    }
}


enum RequestError: Error {
    case noResponse
    case dataUnwrapping
    case dataDecoding
    case sessionDenied
    case userDetailsDecoding
    
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
        case .userDetailsDecoding:
            return "Failed to get user details"
        }
    }
}
