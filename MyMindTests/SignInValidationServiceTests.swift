//
//  SignInValidationServiceTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
@testable import MyMind

class SignInValidationServiceTests: XCTestCase {

    var sut: SignInValidatoinService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SignInValidatoinService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_valid_storeID() {
        let storeID = "AA0002"
        let result = sut.validateStoreID(storeID)
        XCTAssertEqual(result, .valid)
    }

    func test_inValid_storeID() {
        let storeID = "AA0"
        let result = sut.validateStoreID(storeID)
        XCTAssertEqual(result, .invalid("企業帳號長度為5~8碼"))
    }

    func test_valid_account() {
        let account = "tommy"
        let result = sut.validateAccount(account)
        XCTAssertEqual(result, .valid)
    }

    func test_inValid_account() {
        let account = "A0"
        let result = sut.validateAccount(account)
        XCTAssertEqual(result, .invalid("使用者帳號長度為3~20碼"))
    }

    func test_valid_password() {
        let password = "123456"
        let result = sut.validatePassword(password)
        XCTAssertEqual(result, .valid)
    }

    func test_inValid_password() {
        let password = "123"
        let result = sut.validatePassword(password)
        XCTAssertEqual(result, .invalid("密碼長度為6~20碼，英文字母需區分大小寫"))
    }

    func test_valid_captchaValue() {
        let captcha = "43312"
        let result = sut.validateCaptchaValue(captcha)
        XCTAssertEqual(result, .valid)
    }

    func test_inValid_captchaValue() {
        let captcha = "123"
        let result = sut.validateCaptchaValue(captcha)
        XCTAssertEqual(result, .invalid("驗證碼長度為5碼"))
    }

    func test_valid_email() {
        let email = "test@gmail.com"
        let result = sut.validateEmail(email)
        XCTAssertEqual(result, .valid)
    }

    func test_inValid_email() {
        let email = "t@est@gmail.com"
        let result = sut.validateEmail(email)
        XCTAssertEqual(result, .invalid("Email 輸入格式錯誤"))
    }

}
