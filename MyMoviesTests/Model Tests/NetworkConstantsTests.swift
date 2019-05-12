//
//  NetworkConstantsTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 09/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class NetworkConstantsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK:- test Api Keys
    
    func testApiKeys_KeyShouldBeTheSame(){
        XCTAssertEqual(NetworkConstants.ApiKeys.api.rawValue, "6203d05815ada391f8b581d00ebbdbd5")
    }
    func testApiKeys_VersionShouldBeEqualThree() {
        XCTAssertEqual(NetworkConstants.ApiKeys.version.rawValue, "/3")
    }
    func testApiKeys_SchemeShouldBeHTTPS(){
        XCTAssertEqual(NetworkConstants.ApiKeys.scheme.rawValue, "https")
    }
    func testApiKeys_HostShouldBeTheSame() {
        XCTAssertEqual(NetworkConstants.ApiKeys.host.rawValue, "api.themoviedb.org")
    }
    func testApiKeys_ImageHostShouldBeTheSame() {
        XCTAssertEqual(NetworkConstants.ApiKeys.imageHost.rawValue, "image.tmdb.org")
    }
    
    
    // MARK:- test Api Path
    func testApiPath_TodayMoviesPathShouldBeEqual(){
        XCTAssertEqual(NetworkConstants.ApiPaths.todayMovies.rawValue, "/discover/movie")
    }
    
    func testApiPath_ImagePathShouldBeEqual(){
        XCTAssertEqual(NetworkConstants.ApiPaths.image.rawValue, "/t/p/w500")
    }
    
    func testApiPath_SearchPathShouldBeEqual(){
        XCTAssertEqual(NetworkConstants.ApiPaths.search.rawValue, "/search/movie")
    }
    
    
    
    // MARK:- test ApiQueryItems
    func testApiQueryItems_ShoulBeEqual(){
        XCTAssertEqual(NetworkConstants.ApiQueryItems.apiKey.rawValue, "api_key")
        XCTAssertEqual(NetworkConstants.ApiQueryItems.language.rawValue, "language")
        XCTAssertEqual(NetworkConstants.ApiQueryItems.sortBy.rawValue, "sort_by")
        XCTAssertEqual(NetworkConstants.ApiQueryItems.page.rawValue, "page")
        XCTAssertEqual(NetworkConstants.ApiQueryItems.searchQuery.rawValue, "query")
    }
    
}
