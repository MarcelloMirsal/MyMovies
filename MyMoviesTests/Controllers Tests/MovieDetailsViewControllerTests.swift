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
    
    // MARK:- properties.
    func testSutMovie_ShouldBeNilAfterLoading(){ // Only if it has not Injected
        XCTAssertNil(sut.movie)
    }
    
    func testSut_isFavoritedShouldReturnFalseValue(){
        XCTAssertFalse(sut.isFavorited) // Only at first run
        sut.favoriteButton.tintColor = .red // if movie is favorited
        XCTAssertTrue(sut.isFavorited)
        sut.favoriteButton.tintColor = .black // if movie is not favorited
        XCTAssertFalse(sut.isFavorited)
    }
    func testSut_isWatchlistedShouldReturnFalseValue(){
        XCTAssertFalse(sut.isWatchlisted) // Only at first run
        sut.watchListButton.tintColor = .red // if movie is marked
        XCTAssertTrue(sut.isWatchlisted)
        sut.watchListButton.tintColor = .black // if movie is not marked
        XCTAssertFalse(sut.isWatchlisted)
    }
    
    func testSut_SupportedInterfaceOrientationsShouldBePortrait() {
        XCTAssertTrue(sut.supportedInterfaceOrientations == .portrait)
    }
    
    
    // MARK:- test methods
    
    func testSut_setUpTextViewShouldBeFilledWithMovieData(){
        sut.movie = Movie(id: 123456, title: "Action", posterPath: "path", overview: "this is an action movie", releaseDate: "2019-09-20")
        sut.setupTextView()
        let movieData = "\nAction\n \nRelease Date\n2019-09-20\n\nOverview\nthis is an action movie"
        XCTAssertEqual(sut.textView.text, movieData)
    }
    
}
