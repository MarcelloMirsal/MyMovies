//
//  NetworkManagerTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 09/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class NetworkManagerTests: XCTestCase {

    var sut: NetworkManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NetworkManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK:- NetworkManager Tests
    func testSut_ResponseWithoutErrors(){
        let exp = expectation(description: "Api Request Response")
        
        sut.response(for: .todayMovies) { (dataResponse) in
            guard let data = dataResponse.data else {XCTFail();return}
            _ = try! JSONDecoder().decode(ApiResponse<Movie>.self, from: data)
            XCTAssertNil(dataResponse.error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSut_ImageResponseWithoutErrors(){
        let exp = expectation(description: "Image Request Response")
        
        sut.response(imagePath: "/6sOFQDlkY6El1B2P5gklzJfVdsT.jpg") { (dataResponse) in
            
            guard let _ = dataResponse.result.value else {XCTFail();return}
            XCTAssertNil(dataResponse.error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }
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
        let imageURL = URLBuilder.url(for: .image, imagePathURL: imagePath)
        XCTAssertEqual(optimalURL, imageURL)
    }
    
}
