//
//  SearchViewControllerTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 07/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class SearchViewControllerTests: XCTestCase {

    
    var sut: SearchViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SearchViewController()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK:- test UISearchController
    func testSearchController_SutShouldConformToUISearchResultsUpdating(){
        XCTAssertNotNil(sut.searchController.searchResultsUpdater is SearchViewController)
    }
}
