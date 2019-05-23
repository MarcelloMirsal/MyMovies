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

    var sut = NetworkManagerMock()
    
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
    
    func testSut_MarkMediaInListResponseWithoutErrors(){
        let exp = expectation(description: "Post Movie To List")
        
        sut.mark("12345", in: .favorites, with: true) { (isCompleted, error) in
            XCTAssertNil(error)
            XCTAssertTrue(isCompleted)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error)
        }
    }
}


// MARK:- class mock

class NetworkManagerMock: NetworkManager {
    override init() {
        NetworkManager.validatedRequestToken = RequestToken(success: true, expires_at: "2020", request_token: "12345678987654321")
        NetworkManager.userSession = UserSession(success: true, session_id: "98765432123456789")
        NetworkManager.userId = 1234567899
    }
    
    override func mark(_ mediaId: String, in list: UserList, with isListed: Bool, completion: @escaping (Bool, RequestError?) -> ()) {
        
        let responseJSONString = """
{
  "status_code": 12,
  "status_message": "The item/record was updated successfully."
}
"""
        
        guard let data = responseJSONString.data(using: .utf8) else {
            completion(false, .dataUnwrapping)
            return
        }
        
        guard let responseDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any> else {
            completion(false, .markListDictDecoding)
            return
        }
        guard let x : Int = responseDict["status_code"] as? Int, let _: String = responseDict["status_message"] as? String else {
            completion(false, .markListDictDecoding)
            return
        }
        print(x)
        completion(true, nil)
    }

}

