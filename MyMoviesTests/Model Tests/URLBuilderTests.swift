//
//  URLBuilderTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 15/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class URLBuilderTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NetworkManager.validatedRequestToken = RequestToken(success: true, expires_at: "2020", request_token: "12345678987654321")
        NetworkManager.userSession = UserSession(success: true, session_id: "98765432123456789")
        NetworkManager.userId = 1234567899
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK:- test URLBuilder
    func testURLBuilder_TodayMoviesURLShouldBeEqual() {
        let todayMoviesURL = URLBuilder.url(for: .todayMovies)
        let optimalURL = "https://api.themoviedb.org/3/discover/movie?api_key=6203d05815ada391f8b581d00ebbdbd5&language=en-US&sort_by=popularity.desc&page=1"
        XCTAssertEqual(optimalURL, todayMoviesURL)
    }
    
    func testURLBuilder_ImagePathURLShouldBeEqual() {
        let imagePath = "/6sOFQDlkY6El1B2P5gklzJfVdsT.jpg"
        let optimalURL = "https://image.tmdb.org/t/p/w500\(imagePath)"
        let imageURL = URLBuilder.url(for: .image, value: imagePath)
        XCTAssertEqual(optimalURL, imageURL)
    }
    
    func testURLBuilder_SearchPathURLShouldBeEqual() {
        let searchQuery = "Creed"
        let optimalURL = "https://api.themoviedb.org/3/search/movie?api_key=6203d05815ada391f8b581d00ebbdbd5&language=en-US&query=\(searchQuery)&page=1"
        let searchURL = URLBuilder.url(for: .search, value: searchQuery)
        XCTAssertEqual(optimalURL , searchURL)
    }
    
    func testURLBuilder_RequestTokenPathURLShouldBeEqual() {
        let url = URLBuilder.url(for: .requestToken)
        
        XCTAssertEqual(url, "https://api.themoviedb.org/3/authentication/token/new?api_key=\(NetworkConstants.ApiKeys.api.rawValue)")
        
    }
    
    func testURLBuilder_ValidationRequestTokenPathURLShouldBeEqual() {
        let url = URLBuilder.url(for: .tokenValidation)
        
        XCTAssertEqual(url, "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(NetworkConstants.ApiKeys.api.rawValue)")
    }
    
    func testURLBuilder_sessionPathURLShouldBeEqual() {
        let url = URLBuilder.url(for: .session)
        XCTAssertEqual(url, "https://api.themoviedb.org/3/authentication/session/new?api_key=\(NetworkConstants.ApiKeys.api.rawValue)")
    }
    
    
    func testURLBuilder_userDetailsPathURLShouldBeEqual() {
        let optimalURL = "https://api.themoviedb.org/3/account?api_key=\(NetworkConstants.ApiKeys.api.rawValue)&session_id=\(NetworkManager.userSession.session_id)"
        let url = URLBuilder.url(for: .userDetails)
        XCTAssertEqual(optimalURL, url)
    }
    
    
    func testURLBuilder_FavoriteListPathURLShouldBeEqual() {
        let optimalURL = "https://api.themoviedb.org/3/account/\(NetworkManager.userId!)/favorite/movies?api_key=\(NetworkConstants.ApiKeys.api.rawValue)&session_id=\(NetworkManager.userSession.session_id)&language=en-US&sort_by=created_at.asc&page=1"
        let url = URLBuilder.url(for: .favoriteList)
        XCTAssertEqual(optimalURL, url)
    }
    
    func testURLBuilder_WatchListPathURLShouldBeEqual() {
        let optimalURL = "https://api.themoviedb.org/3/account/\(NetworkManager.userId!)/watchlist/movies?api_key=\(NetworkConstants.ApiKeys.api.rawValue)&language=en-US&session_id=\(NetworkManager.userSession.session_id)&sort_by=created_at.asc&page=1"
        let url = URLBuilder.url(for: .watchList)
        XCTAssertEqual(optimalURL, url)
    }
    
}
