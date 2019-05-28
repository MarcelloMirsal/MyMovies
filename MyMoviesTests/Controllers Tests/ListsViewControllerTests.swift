//
//  ListsViewControllerTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 06/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class ListsViewControllerTests: XCTestCase {

    var sut: ListsViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NetworkManager.validatedRequestToken = RequestToken(success: true, expires_at: "2020", request_token: "12345678987654321")
        NetworkManager.userSession = UserSession(success: true, session_id: "98765432123456789")
        NetworkManager.userId = 1234567899
        sut = ListsViewController()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- test properties
    func testSut_ListTypeShouldBeFavoritesWhenLoading() {
        XCTAssertEqual(sut.listType, UserList.favorites)
    }
    
    func testTableViewPrefetchApi_ShouldBeEqualToSut(){
        XCTAssertTrue(sut.tableView.prefetchDataSource is ListsViewController)
    }
    
    

}
