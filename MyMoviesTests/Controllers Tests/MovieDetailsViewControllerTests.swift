//
//  MovieDetailsViewControllerTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 05/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class MovieDetailsViewControllerTests: XCTestCase {

    var sut: MovieDetailsViewController!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MovieDetailsViewController()
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- test movie property
    func testSutMovie_ShouldBeNilAfterLoading(){ // Only if it has not Injected
        XCTAssertNil(sut.movie)
    }
    
}
