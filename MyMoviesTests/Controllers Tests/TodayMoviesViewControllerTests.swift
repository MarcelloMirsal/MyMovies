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
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: sut.movieCellId, for: indexPath) as? MovieCell
        XCTAssertNotNil(dequeuedCell)
    }
    func testCollectionViewCanInsertCell_ShouldBeInsertedAtProperIndexPath(){
        let newMovie = "Movie4"
        sut.moviesMock.append(newMovie)
        sut.collectionView.reloadData()
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), sut.moviesMock.count)
    }

}

// MARK:- SUT Class Mock


class TodayMoviesViewControllerMock: TodayMoviesViewController {
    
    
    var moviesMock = [ "Movie1", "Movie2", "Movie3" ]
    let movieCellId = "MovieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: movieCellId)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesMock.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellId, for: indexPath) as! MovieCell
        return cell
    }
    
    
    
    
}
