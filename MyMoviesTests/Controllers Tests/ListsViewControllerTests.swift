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
        sut = ListsViewController()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- test properties
    func testSut_ListTypeShouldBeFavorites() {
        XCTAssertEqual(sut.listType, ListsViewController.List.favorites)
    }
    

}
