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

    var sut = NetworkManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // MARK:- test properties
    
    
    
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
    
    func testSut_RequestTokenResponseWithoutErrorsAndNotNil(){
        let exp = expectation(description: "Request Token Validation")
        
        sut.session(username: NetworkConstants.demoUser, password: NetworkConstants.demoPassword) { (isSuccess, error) in
            // test error must be nil = no errors
            XCTAssertNil(error)
            // test isSuccess
            XCTAssertTrue(isSuccess)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }
    }
}
