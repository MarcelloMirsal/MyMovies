//
//  TodayMoviesViewControllerTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class TodayMoviesViewControllerTests: XCTestCase {

    var sut: TodayMoviesViewControllerMock!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = TodayMoviesViewControllerMock()
        _ = sut.view
    }
        
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- Testing CollectionView
    func testCollectionViewDelegateAndDataSource_ShouldBeEqualToSUT(){
        XCTAssertTrue(sut.collectionView.delegate is TodayMoviesViewController)
        XCTAssertTrue(sut.collectionView.dataSource is TodayMoviesViewController)
    }
    func testCollectionViewCanDequeueCell_ShouldBeMovieCell() {
        let collectionView = sut.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellId, for: indexPath)
        XCTAssertNotNil(cell is MovieCell)
    }
    func testCollectionViewCanInsertCell_ShouldBeAdded(){
        let collectionView = sut.collectionView
        let newMovie = Movie(id: 14, title: "Movie5", posterPath: "posterPath", overview: "overview", releaseDate: "releaseDate", voteAverage: 0.5)
        sut.apiResponse.results.append(newMovie)
        let indexPath = IndexPath(item: sut.apiResponse.results.count-1, section: 0)
        collectionView.reloadData()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellId, for: indexPath) as? MovieCell
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), sut.apiResponse.results.count)
        XCTAssertNotNil(cell)
    }
    
    func testCollectionViewPrefetchApi_ShouldBeEqualToSut(){
        XCTAssertTrue(sut.collectionView.prefetchDataSource is TodayMoviesViewControllerMock)
    }
    
}

// MARK:- SUT Class Mock
class TodayMoviesViewControllerMock: TodayMoviesViewController {
    
    let movieCellId = "MovieCell"
    
    override func viewDidLoad() {
        setupAppearance()
        setupCollectionView()
        setupViews()
        apiResponse = nil
        let movies = [
            Movie(id: 1, title: "Movie1", posterPath: "posterPath", overview: "overview", releaseDate: "releaseDate", voteAverage: 0.5),
            Movie(id: 12, title: "Movie2", posterPath: "posterPath", overview: "overview", releaseDate: "releaseDate", voteAverage: 0.5),
            Movie(id: 13, title: "Movie3", posterPath: "posterPath", overview: "overview", releaseDate: "releaseDate", voteAverage: 0.5),
            Movie(id: 14, title: "Movie4", posterPath: "posterPath", overview: "overview", releaseDate: "releaseDate", voteAverage: 0.5)
        ]
        apiResponse = ApiResponse<Movie>(page: 1, totalPages: 123, results: movies)
        collectionView.reloadData()
    }
    
    
}
