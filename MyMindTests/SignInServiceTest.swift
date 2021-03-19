//
//  SignInServiceTest.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/19.
//

import XCTest
import RxBlocking
@testable import MyMind

class SignInServiceTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_captcha_observable() {
        let service = SignInService()
        do {
            let result = try service.captcha().toBlocking(timeout: 3).first()
            XCTAssertNotNil(result)
        } catch let error {
            XCTFail(error.localizedDescription)
        }

    }

}
