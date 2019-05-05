//
//  AppDelegateTests.swift
//  MyMoviesTests
//
//  Created by Marcello Mirsal on 04/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import XCTest
@testable import MyMovies

class AppDelegateTests: XCTestCase {

    // SUT: System Under Test
    let sut = UIApplication.shared.delegate as! AppDelegate
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK:- Testing Window
    func testWindow_isNotNil(){
        XCTAssertNotNil(sut.window)
    }
    
    func testWindowIsKeyed_ShouldBeTrue(){
        XCTAssertTrue(sut.window?.isKeyWindow ?? false)
    }
    
    // MARK:- Testing Root ViewController For Window
    func testRootViewController_isNotNil() {
        XCTAssertNotNil(sut.window?.rootViewController)
    }
    
    func testRootViewController_isLoginViewController() {
        XCTAssert(sut.window?.rootViewController is LoginViewController)
    }
}
