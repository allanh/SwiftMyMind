//
//  AuthServiceTest.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/19.
//

import XCTest
import PromiseKit
@testable import MyMind

class AuthServiceTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_captcha_observable() {
        var captchaSession: CaptchaSession?
        let service = MyMindAuthService()

        let exp = expectation(description: "captcha")
        service.captcha()
            .done { session in
                captchaSession = session
                exp.fulfill()
            }
            .cauterize()

        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertNotNil(captchaSession)
    }

}
